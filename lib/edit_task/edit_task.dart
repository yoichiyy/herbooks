// import 'package:book_list_sample/domain/book.dart';
// import 'package:book_list_sample/edit_book/edit_book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../task_list/task_model.dart';
import 'edit_task_model.dart';

class EditTaskPage extends StatefulWidget {
  final Todo todo;
  const EditTaskPage(this.todo, {Key? key}) : super(key: key);

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  // bool checkBox = true;

  late EditTaskModel model;
  //TODO:lateとは？　ここでなんで使ってるのか？
  //地獄の解説　：　1.遅延初期化 2.宣言後に初期化されるnon-nullable変数の宣言
  //…を、もう少し　噛み砕いた表現でいけないものだろうか？

  @override //じゃあこのoverrideは、initStateについて、どういう意味を持たせている？
  void initState() {
    model = EditTaskModel(widget.todo);
    super.initState();
  }

  @override //TODO:buildメソッドなんだけどさ、単なるウィジェットじゃなくて、Statelessウィジェットだよ？いいね？
  //dart言語のはなし。クラスの継承。上に抽象的なクラス定義。そのメソッドを継承。
  //のりものクラス（一番上）→これを継承して、無知でたたくとか。追加トッピング。
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
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
                      '${model.todo.dueDate?.month}/${model.todo.dueDate?.day}  ${model.todo.dueDate?.hour}時',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
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
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.blue, // Onになった時の色を指定
                          value:
                              model.todo.repeatOption, // チェックボックスのOn/Offを保持する値
                          onChanged: (bool? e) {
                            //関数を渡している。callback関数。
                            setState(() {
                              model.updateRepeatOption(e!);
                            });
                          }),
                      const Text("リピートする"),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("知"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            model.todo.intelligence = value.toInt();
                          });
                        },
                        value: model.todo.intelligence.toDouble(),
                        max: 5,
                        min: 0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white,
                        divisions: 5,
                        label: "$model.todo.intelligence",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("♡"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            model.todo.care = value.toInt();
                          });
                        },
                        value: model.todo.care.toDouble(),
                        max: 5,
                        min: 0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white,
                        divisions: 5,
                        label: "$model.todo.care",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("力"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            model.todo.power = value.toInt();
                          });
                        },
                        value: model.todo.power.toDouble(),
                        max: 5,
                        min: 0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white,
                        divisions: 5,
                        label: "$model.todo.power",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("技"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            model.todo.skill = value.toInt();
                          });
                        },
                        value: model.todo.skill.toDouble(),
                        max: 5,
                        min: 0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white,
                        divisions: 5,
                        label: "$model.todo.skill",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("根性"),
                      ),
                      Slider(
                        onChanged: (value) {
                          setState(() {
                            model.todo.patience = value.toInt();
                          });
                        },
                        value: model.todo.patience.toDouble(),
                        max: 5,
                        min: 0,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.white,
                        divisions: 5,
                        label: "$model.todo.patience",
                      ),
                    ],
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
