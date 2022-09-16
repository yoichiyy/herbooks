import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/count_button.dart';
import 'package:counter/counter/fab_button.dart';
import 'package:counter/counter/homeCard.dart';
import 'package:counter/counter/count_model.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:counter/counter/count_area.dart';
import '../utils/date_time.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("ehon"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            HomeCardWidget(
              title: "えほん",
              color: Colors.white60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  countArea(),
                  Center(
                    //Button_area
                    child: Column(
                      children: [
                        const FabButton(
                          booknum: 1,
                        ),
                        const SizedBox(
                          width: 10,
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CountButton(
                              booknum: 3,
                            ),
                            SizedBox(
                              width: 30,
                              height: 60,
                            ),
                            CountButton(
                              booknum: 5,
                            ),
                            SizedBox(
                              width: 30,
                              height: 60,
                            ),
                            CountButton(
                              booknum: -1,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: double.infinity,
                          height: 20,
                        ),
                      ], //children
                    ),
                  ),
                ],
              ),
            ),
            const HomeCardWidget(
              title: "TODO",
              color: Colors.white12,
              // color: Colors.amber[100], //これならうまくいかぬのはなぜ？FQ：
              // ここにあるのに→　https://api.flutter.dev/flutter/material/Colors-class.html
              child: TaskCard(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
      // ),
    );
  }
}

//TASKカードセクション
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

  DateTime _pickedDate = DateTime.now();
  final snackBar = const SnackBar(
    content: Text('登録しました'),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
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
                height: 20,
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
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.grey[400],
                    //   onPrimary: Colors.black,
                    //   textStyle: const TextStyle(
                    //     fontSize: 10,
                    //   ),
                    // ),
                    onPressed: () async {
                      final _result = await showDatePicker(
                        context: context,
                        currentDate: _pickedDate,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 0)),
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
                height: 10,
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
                height: 10,
              ),
            ],
          ),
        ),

        //登録ボタン
        MaterialButton(
          color: Colors.lightBlue.shade900,
          onPressed: () async {
            if (_controller.text.isEmpty) {
              showDialog(
                context: context, //FQ：contextは何の情報を渡している？一度デバッグで見られるかな？
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
            await FirebaseFirestore.instance
                .collection('todoList') // コレクションID指定
                .doc() // ドキュメントID自動生成
                .set({
              'title': _controller.value.text, //stringを送る
              'createdAt': _pickedDate //本当はタイムスタンプ　「サーバー　タイムスタンプ」検索
            });
            _controller.clear();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    );
  }
}
