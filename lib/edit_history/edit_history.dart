import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../counter_history/history_model.dart';
import 'edit_history_model.dart';

class EditHistoryPage extends StatelessWidget {
  final History history;
  const EditHistoryPage(this.history, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditHistoryModel>(
      create: (_) => EditHistoryModel(history),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('履歴を編集'),
        ),
        body: Center(
          child: Consumer<EditHistoryModel>(builder: (_, model, __) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //datetimepicker　はりつけ
                  Text(
                    model.history.dateString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
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
                    // onChanged: (text) {
                    //   model.setCountHistory(text);
                    // },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton(
                    child: const Text('更新'),
                    onPressed:
                        // model.isUpdatedBookNum()                        ?
                        () async {
                      // 追加の処理
                      try {
                        await model.update();
                        Navigator.of(context).pop(model.bookNumForEditpage);
                        debugPrint("カウント履歴編集して、navigatorで渡した");
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
          }),
        ),
      ),
    );
  }
}
