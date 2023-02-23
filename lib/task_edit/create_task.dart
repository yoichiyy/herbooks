import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../task_list/task_list.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key}) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int intelligence = 0;
  int care = 0;
  int power = 0;
  int skill = 0;
  int patience = 0;
  int thanks = 0;
  int total = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  DateTime _pickedDate = DateTime.now();
  bool repeatOption = true;
  final snackBar = const SnackBar(
    content: Text('登録しました'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Task"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacement<MaterialPageRoute, TaskListPage>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskListPage(),
                  ));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: "やること"),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _pickedDate = DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day + 1,
                                  DateTime.now().hour,
                                  DateTime.now().minute,
                                ));
                            debugPrint(_pickedDate.toString());
                          },
                          child: const Text("明日"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _pickedDate = DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day + 7,
                                  DateTime.now().hour,
                                  DateTime.now().minute,
                                ));
                            debugPrint(_pickedDate.toString());
                          },
                          child: const Text("来週"),
                        ),
                        ElevatedButton(
                          child: const Text("日付指定"),
                          onPressed: () async {
                            final _result = await showDatePicker(
                              context: context,
                              currentDate: _pickedDate,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 0)),
                              lastDate: DateTime.now().add(
                                const Duration(days: 3 * 365),
                              ),
                            );
                            if (_result != null) {
                              _pickedDate = _result;
                            }

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _pickedDate = DateTime(
                                  _pickedDate.year,
                                  _pickedDate.month,
                                  _pickedDate.day,
                                  6,
                                ));
                            debugPrint(_pickedDate.toString());
                          },
                          child: const Text("朝"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _pickedDate = DateTime(
                                  _pickedDate.year,
                                  _pickedDate.month,
                                  _pickedDate.day,
                                  12,
                                ));
                            debugPrint(_pickedDate.toString());
                          },
                          child: const Text("昼"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _pickedDate = DateTime(
                                  _pickedDate.year,
                                  _pickedDate.month,
                                  _pickedDate.day,
                                  19,
                                ));
                            debugPrint(_pickedDate.toString());
                          },
                          child: const Text("夜"),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                      height: 4,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: Colors.blue, // Onになった時の色を指定
                            value: repeatOption, // チェックボックスのOn/Offを保持する値
                            onChanged: (bool? e) {
                              //関数を渡している。callback関数。
                              setState(() {
                                repeatOption = e!;
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
                              intelligence = value.toInt();
                            });
                          },
                          value: intelligence.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$intelligence",
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
                              care = value.toInt();
                            });
                          },
                          value: care.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$care",
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
                              power = value.toInt();
                            });
                          },
                          value: power.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$power",
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
                              skill = value.toInt();
                            });
                          },
                          value: skill.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$skill",
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
                              patience = value.toInt();
                            });
                          },
                          value: patience.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$patience",
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
                          child: Text("thanks"),
                        ),
                        Slider(
                          onChanged: (value) {
                            setState(() {
                              thanks = value.toInt();
                            });
                          },
                          value: thanks.toDouble(),
                          max: 5,
                          min: 0,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white,
                          divisions: 5,
                          label: "$thanks",
                        ),
                      ],
                    )
                  ], //children
                ),
              ),

              //登録ボタン
              MaterialButton(
                color: Colors.lightBlue.shade900,
                onPressed: () async {
                  if (_controller.text.isEmpty) {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Oops"),
                          content: const Text("ちゃんと書きなさい"),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  } //if
                  final snapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get();
                  String userName = snapshot.data()!['name'];

                  await FirebaseFirestore.instance
                      .collection('todoList')
                      .doc()
                      .set(<String, dynamic>{
                    'title': _controller.value.text, //stringを送る
                    'dueDate': _pickedDate, //本当はタイムスタンプ　「サーバー　タイムスタンプ」検索
                    'intelligence': intelligence,
                    'care': care,
                    'power': power,
                    'skill': skill,
                    'patience': patience,
                    'repeatOption': repeatOption,
                    'thanks': thanks,
                    'user': userName,
                  });
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "登録",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ); //scaffold
  } //widget build
}
