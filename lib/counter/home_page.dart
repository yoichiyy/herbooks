import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/homeCard.dart';
import 'package:counter/counter/count_model.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../utils/date_time.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //consumer statefulninatteirunoで、再度取得するコードかくでもOK
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final historyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<CounterModel>(
    //   create: (_) => CounterModel(_),
    //   child: Scaffold(
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("ehon"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: HomeCardWidget(
              title: "えほん",
              color: Colors.white60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _countArea(),
                  Center(
                    //Button_area
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('ehoncount')
                              .doc() // ドキュメントID自動生成
                              .set({
                            'ehon_year': "${DateTime.now().year}",
                            'ehon_month': "${DateTime.now().month}",
                            'ehon_date': "${DateTime.now().day}",
                            'ehon_pm': "plus"
                          });
                          //1
                          FirebaseFirestore.instance
                              .collection('historyCounter')
                              .doc(historyCount)
                              .get()
                              .then(
                                (docSnapshot) => {
                                  if (docSnapshot.exists)
                                    {
                                      FirebaseFirestore.instance
                                          .collection('historyCounter')
                                          .doc(historyCount)
                                          .update({
                                        "count": FieldValue.increment(1)
                                      })
                                    }
                                  else
                                    {
                                      FirebaseFirestore.instance
                                          .collection('historyCounter')
                                          .doc(historyCount)
                                          .set(
                                        {
                                          "date":
                                              "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                                          //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                                          //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                                          "count": 1,
                                        },
                                      ),
                                    },
                                },
                              );
                          setState(() {
                            getCounterForDay(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day);
                            getCounterForMonth(
                                DateTime.now().year, DateTime.now().month);
                            getCounterForAll();
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 3,
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

  Widget _countArea() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                  future: getCounterForDay(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "今日: ${snapshot.data}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                future: getCounterForMonth(
                    DateTime.now().year, DateTime.now().month),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "今月: ${snapshot.data}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(4),
              child: FutureBuilder<int>(
                  // future: getCounterForDay(DateTime.now()),
                  future: getCounterForAll(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "全部: ${snapshot.data}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

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
    super.dispose(); //このsuperはなんでしょう。FQ：
    // flutter stateful dispose
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
//１．singlechild scroll view　→　すくろールできるようにする方法もある。
//expanded 1:2　になってるので、これをやめないと。高さを固定するなど。

                        controller: _controller,
                        decoration: const InputDecoration(hintText: "やること"),
                      ),
                    ),
                    ElevatedButton(
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
                      child: const Text("日付指定"),
                    ),
                  ],
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
                      onPressed: () {
                        setState(() => _pickedDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month + 1,
                              DateTime.now().day,
                              DateTime.now().hour,
                              DateTime.now().minute,
                            ));
                        debugPrint(_pickedDate.toString());
                      },
                      child: const Text("来月〜"),
                    )
                  ],
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

        //これも、上のexpandedの中にどうして入れることができないか？
        MaterialButton(
          color: Colors.lightBlue.shade900,
          onPressed: () async {
            if (_controller.text.isEmpty) {
              showDialog(
                context: context, //FQ：contextは何の情報を渡している？一度デバッグで見られるかな？
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Oops"),
                    content: const Text("You need to add a task"),
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
