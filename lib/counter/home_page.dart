import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: HomeCardWidget(
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
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: FloatingActionButton(
                            onPressed: () async {
                              //全カウント登録
                              FirebaseFirestore.instance
                                  .collection('totalCount')
                                  .doc(totalCount)
                                  .get()
                                  .then(
                                    //ここから
                                    (docSnapshot) => {
                                      if (docSnapshot.exists)
                                        {
                                          FirebaseFirestore.instance
                                              .collection('totalCount')
                                              .doc(totalCount)
                                              .update({
                                            "count": FieldValue.increment(1)
                                          })
                                        }
                                      else
                                        {
                                          FirebaseFirestore.instance
                                              .collection('totalCount')
                                              .doc(totalCount)
                                              .set(
                                            {
                                              "count": 1,
                                            },
                                          ),
                                        },
                                    },
                                  ); //then

                              //月単位のカウンター登録
                              FirebaseFirestore.instance
                                  .collection('monthlyCount')
                                  .doc(monthlyCount)
                                  .get()
                                  .then(
                                    //ここから
                                    (docSnapshot) => {
                                      if (docSnapshot.exists)
                                        {
                                          FirebaseFirestore.instance
                                              .collection('monthlyCount')
                                              .doc(monthlyCount)
                                              .update({
                                            "count": FieldValue.increment(1)
                                          })
                                        }
                                      else
                                        {
                                          FirebaseFirestore.instance
                                              .collection('monthlyCount')
                                              .doc(monthlyCount)
                                              .set(
                                            {
                                              "date": monthlyCount,
                                              //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                              //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                              "count": 1,
                                            },
                                          ),
                                        },
                                    },
                                  ); //then

                              //日単位のカウンター登録
                              FirebaseFirestore.instance
                                  .collection('dailyCount')
                                  .doc(dailyCount)
                                  .get()
                                  .then(
                                    //ここから
                                    (docSnapshot) => {
                                      if (docSnapshot.exists)
                                        {
                                          FirebaseFirestore.instance
                                              .collection('dailyCount')
                                              .doc(dailyCount)
                                              .update({
                                            "count": FieldValue.increment(1)
                                          })
                                        }
                                      else
                                        {
                                          FirebaseFirestore.instance
                                              .collection('dailyCount')
                                              .doc(dailyCount)
                                              .set(
                                            {
                                              "date": dailyCount,
                                              "date_string":
                                                  "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                                              //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                              //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                              "count": 1,
                                            },
                                          ),
                                        },
                                    },
                                  ); //then

                              setState(() {
                                debugPrint("setState実行");
                                getCounterForDay(dailyCount);
                                getCounterForMonth(monthlyCount);
                                getCounterForAll();
                              });
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ElevatedButton(
                                child: const Text('3'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[300],
                                  onPrimary: Colors.purple,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  //全カウント登録
                                  FirebaseFirestore.instance
                                      .collection('totalCount')
                                      .doc(totalCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .update({
                                                "count": FieldValue.increment(3)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .set(
                                                {
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //月単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('monthlyCount')
                                      .doc(monthlyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .update({
                                                "count": FieldValue.increment(3)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .set(
                                                {
                                                  "date": monthlyCount,
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //日単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('dailyCount')
                                      .doc(dailyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .update({
                                                "count": FieldValue.increment(3)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .set(
                                                {
                                                  "date": dailyCount,
                                                  "date_string":
                                                      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then
                                  //順番関係ないけど、終わってから次に行きたいとき。並行処理できない。効率悪い。
                                  await Future.wait<void>([
                                    getCounterForDay(dailyCount),
                                    getCounterForMonth(monthlyCount),
                                    getCounterForAll(),
                                  ]);

                                  setState(() {
                                    debugPrint("setState実行");
                                    // getCounterForDay(dailyCount);
                                    // getCounterForMonth(monthlyCount);
                                    // getCounterForAll();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 60,
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ElevatedButton(
                                child: const Text('5'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[300],
                                  onPrimary: Colors.purple,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  //全カウント登録
                                  FirebaseFirestore.instance
                                      .collection('totalCount')
                                      .doc(totalCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .update({
                                                "count": FieldValue.increment(5)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .set(
                                                {
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //月単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('monthlyCount')
                                      .doc(monthlyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .update({
                                                "count": FieldValue.increment(5)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .set(
                                                {
                                                  "date": monthlyCount,
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //日単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('dailyCount')
                                      .doc(dailyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .update({
                                                "count": FieldValue.increment(5)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .set(
                                                {
                                                  "date": dailyCount,
                                                  "date_string":
                                                      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  setState(() {
                                    debugPrint("setState実行");
                                    getCounterForDay(dailyCount);
                                    getCounterForMonth(monthlyCount);
                                    getCounterForAll();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 60,
                            ),
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: ElevatedButton(
                                child: const Text('-1'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[300],
                                  onPrimary: Colors.purple,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onPressed: () async {
                                  //全カウント登録
                                  FirebaseFirestore.instance
                                      .collection('totalCount')
                                      .doc(totalCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .update({
                                                "count":
                                                    FieldValue.increment(-1)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('totalCount')
                                                  .doc(totalCount)
                                                  .set(
                                                {
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //月単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('monthlyCount')
                                      .doc(monthlyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .update({
                                                "count":
                                                    FieldValue.increment(-1)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('monthlyCount')
                                                  .doc(monthlyCount)
                                                  .set(
                                                {
                                                  "date": monthlyCount,
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  //日単位のカウンター登録
                                  FirebaseFirestore.instance
                                      .collection('dailyCount')
                                      .doc(dailyCount)
                                      .get()
                                      .then(
                                        //ここから
                                        (docSnapshot) => {
                                          if (docSnapshot.exists)
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .update({
                                                "count":
                                                    FieldValue.increment(-1)
                                              })
                                            }
                                          else
                                            {
                                              FirebaseFirestore.instance
                                                  .collection('dailyCount')
                                                  .doc(dailyCount)
                                                  .set(
                                                {
                                                  "date": dailyCount,
                                                  "date_string":
                                                      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                                                  //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                                  //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                                  "count": 1,
                                                },
                                              ),
                                            },
                                        },
                                      ); //then

                                  setState(() {
                                    debugPrint("setState実行");
                                    getCounterForDay(dailyCount);
                                    getCounterForMonth(monthlyCount);
                                    getCounterForAll();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: HomeCardWidget(
              title: "TODO",
              color: Colors.white12,
              // color: Colors.amber[100], //これならうまくいかぬのはなぜ？FQ：
              // ここにあるのに→　https://api.flutter.dev/flutter/material/Colors-class.html
              child: TaskCard(),
            ),
          ),
        ],
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
        Expanded(
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  //１．singlechild scroll view　→　すくろールできるようにする方法もある。
                  //expanded 1:2　になってるので、これをやめないと。高さを固定するなど。
                  controller: _controller,
                  decoration: const InputDecoration(hintText: "やること"),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 30,
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
                  height: 20,
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
              ],
            ),
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
            debugPrint("登録しました");
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
      ],
    );
  }
}
