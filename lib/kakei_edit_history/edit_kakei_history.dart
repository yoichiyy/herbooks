import 'package:counter/edit_history/edit_history_model.dart';
import 'package:counter/kakei_history/history_model_kakei.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'edit_kakei_history_model.dart';

class EditKakeiHistoryPage extends StatelessWidget {
  final KakeiHistory kakeiHistory;
  const EditKakeiHistoryPage(this.kakeiHistory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditKakeiHistoryModel>(
      create: (_) => EditKakeiHistoryModel(kakeiHistory),
      child: Scaffold(
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
                    //現在の、日付を表示するだけのやつ
                    Text(
                      model.history.dateString,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

//日付編集できるやつ：datetimepicker はりつけ
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: model.bookDateController,
                      decoration: const InputDecoration(
                        hintText: '読んだ数',
                      ),
                      // onChanged: (text) {
                      //   model.setCountHistory(text);
                      // },
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
                          // model.isUpdatedBookNum()  ?
                          () async {
                        // 追加の処理
                        try {
                          await model.update();
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
      ),
    );
  }
}
