import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../counter_history/history_model.dart';
import 'edit_history_model.dart';

class EditHistoryPage extends StatefulWidget {
  final History history;
  const EditHistoryPage(this.history, {Key? key}) : super(key: key);

  @override
  State<EditHistoryPage> createState() => _EditHistoryPageState();
}
//なぜ、initstateここでは呼ばれていない？他との違いは？
//じつは呼ばれている。でも明示的に書くなら。

class _EditHistoryPageState extends State<EditHistoryPage> {
  @override //これ。
  void initState() {
    super.initState(); //継承もとの親クラス。
  }

  DateTime _pickedDate = DateTime.now();
  bool isDateChanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴を編集'),
      ),
      body: Center(
        child: Consumer<EditHistoryModel>(
          builder: (_, model, __) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextButton(
                    child: isDateChanged
                        ? const Text("変更済")
                        : Text(model.history.dateString),
                    onPressed: () async {
                      final _result = await showDatePicker(
                        context: context,
                        currentDate: _pickedDate,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(
                          const Duration(days: 7),
                        ),
                      );
                      if (_result != null) {
                        isDateChanged = true;
                        _pickedDate = _result;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: model.bookNumController,
                    decoration: const InputDecoration(
                      hintText: '読んだ数',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    child: const Text('更新'),
                    onPressed:
                        // model.isUpdatedBookNum()  ?
                        () async {
                      // 追加の処理
                      try {
                        await model.update(_pickedDate);
                        Navigator.of(context).pop(model.bookNumForEditpage);
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    // : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
