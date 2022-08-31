// import 'package:book_list_sample/domain/book.dart';
// import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../task_list/task_model.dart';
import '../task_list/todo_class.dart';
import 'edit_task_model.dart';

class EditTaskPage extends StatelessWidget {
  final Todo todo;
  const EditTaskPage(this.todo, {Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditTaskModel>(
      create: (_) => EditTaskModel(todo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('タスクを編集'),
        ),
        body: Center(
          child: Consumer<EditTaskModel>(builder: (_, model, __) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //datetimepicker　はりつけ
                  TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2022, 3, 5),
                        maxTime: DateTime(2025, 6, 7),
                        onChanged: (date) {
                          debugPrint('change $date');
                        }, //ここもです。
                        onConfirm: (dateSelected) {
                          model.updateForFirebase(dateSelected);
                          // model.updateDueDateText(dateSelected.toString());
                          //viewとmodel　更新系＝モデルでやるべし。notifilistenersたたけないから。
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.jp,
                      );
                    },
                    child: Text(
                      '${model.todo.createdAt?.month}/${model.todo.createdAt?.day}  ${model.todo.createdAt?.hour}時',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Text( 討ち死にしたコード
                  //     "${model.createdAtForDisplay.toDate().month}/${model.createdAtForDisplay.toDate().day}  ${model.createdAtForDisplay.toDate().hour}時"),

                  const SizedBox(
                    height: 8,
                  ),

                  TextField(
                    controller: model.taskNameController,
                    decoration: const InputDecoration(
                      hintText: '日付',
                    ),
                    onChanged: (text) {
                      model.setTaskName(text);
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 追加の処理
                            try {
                              await model.update();
                              //FQ：popの引数は、「遷移先ページに、タスク名更新したからこれを使ってね。」でOKか？
                              Navigator.of(context)
                                  .pop(model.taskNameForEditpage);
                              debugPrint("タスク編集しています");
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: const Text('更新'),
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
