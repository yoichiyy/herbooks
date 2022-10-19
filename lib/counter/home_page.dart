import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/fab_button.dart';
import 'package:counter/counter/homeCard.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:counter/counter/count_area.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

import 'fab_button_old.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";
  final _controller =
      ConfettiController(duration: const Duration(milliseconds: 500));
      

  void _confettiEvent() {
    setState(() {
      _controller.play(); // ココ！
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // controllerを破棄する
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<FabButton>(
        create: (_) => FabButton(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("haruEhon"),
          ),
          body: Consumer<FabButton>(
            builder: (context, model, child) {
              return SingleChildScrollView(
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
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FloatingActionButton(
                                    child: const Icon(Icons.add),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact(); // ココ！
                                      //void call back　または　function
                                      _confettiEvent();
                                      // _controller.play(); // ココ！
                                      debugPrint("confetti実行");
                                      model.fabButtonFunction(1);
                                    },
                                  ),
                                ),
                                ConfettiWidget(
                                  confettiController: _controller,
                                  blastDirectionality:
                                      BlastDirectionality.explosive,
                                  blastDirection: pi / 2,
                                  // 紙吹雪を出す方向(この場合画面上に向けて発射)
                                  emissionFrequency:
                                      0.9, // 発射頻度(数が小さいほど紙と紙の間隔が狭くなる)
                                  minBlastForce: 5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
                                  maxBlastForce:
                                      10, // 紙吹雪の出る瞬間の5フレーム分の速度の最大(数が大きほど紙吹雪は遠くに飛んでいきます。)
                                  numberOfParticles: 7, // 1秒あたりの紙の枚数
                                  gravity: 0.5, // 紙の落ちる速さ(0~1で0だとちょーゆっくり)
                                  // colors: const <Color>[
                                  //   // 紙吹雪の色指定
                                  //   Colors.red,
                                  //   Colors.blue,
                                  //   //最初Colorsでなく、Constants、となっていた。
                                  //   Colors.green,
                                  // ],
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
                                        child: const Text("3"),
                                        style: ElevatedButton.styleFrom(
                                          //backgroundColor,foregroundColor
                                          backgroundColor: Colors.grey[300],
                                          foregroundColor: Colors.purple,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.mediumImpact(); // ココ！
                                          model.fabButtonFunction(3);
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
                                        child: const Text("5"),
                                        style: ElevatedButton.styleFrom(
                                          //backgroundColor,foregroundColor
                                          backgroundColor: Colors.grey[300],
                                          foregroundColor: Colors.purple,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.mediumImpact(); // ココ！
                                          model.fabButtonFunction(5);
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
                                        child: const Text("-1"),
                                        style: ElevatedButton.styleFrom(
                                          //backgroundColor,foregroundColor
                                          backgroundColor: Colors.grey[300],
                                          foregroundColor: Colors.purple,
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        onPressed: () async {
                                          HapticFeedback.mediumImpact();
                                          model.fabButtonFunction(-1);
                                        },
                                      ),
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
              );
            },
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 1),
        ),
      ),
    );
  } //widget build
} //class

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
                      HapticFeedback.mediumImpact(); // ココ！
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
                      HapticFeedback.mediumImpact(); // ココ！
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
                      HapticFeedback.mediumImpact(); // ココ！
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

                      // setState(() {});
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
                      HapticFeedback.mediumImpact();
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
                      HapticFeedback.mediumImpact();
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
                      HapticFeedback.mediumImpact();
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
            HapticFeedback.mediumImpact();
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
