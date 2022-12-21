import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:counter/counter/num_count.dart';
import 'package:counter/counter/home_card.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:counter/counter/book_count_area.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import '../ui/goal_setting_page.dart';
import 'kakei_count_area.dart';

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
  final _controllerHaru =
      ConfettiController(duration: const Duration(milliseconds: 500));
  final _controllerYume =
      ConfettiController(duration: const Duration(milliseconds: 500));
  // DateTime _pickedDate = DateTime.now();
  String category = "";

  void _confettiEventHaru() {
    setState(() {
      _controllerHaru.play(); // ココ！
    });
  }

  void _confettiEventYume() {
    setState(() {
      _controllerYume.play(); // ココ！
    });
  }

  @override
  void dispose() {
    _controllerHaru.dispose(); // controllerを破棄する
    _controllerYume.dispose(); // controllerを破棄する
    super.dispose();
  }

  final snackBar = const SnackBar(
    content: Text('登録しました'),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<NumCountModel>(
        create: (_) => NumCountModel()..getGraphData(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Ehon"),
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: OutlinedButton(
                    child:
                        const Text('設定', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoalSetting(),
                        ),
                      );
                    },
                  ))
            ],
          ),
          body: Consumer<NumCountModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//グラフ部分
//グラフ１：青
                    // Padding(
                    //   padding: const EdgeInsets.all(15.0),
                    //   child: LinearPercentIndicator(
                    //     width: MediaQuery.of(context).size.width - 100,
                    //     lineHeight: 14.0,
                    //     percent: 0.5,
                    //     center: const Text(
                    //       "50.0%",
                    //       style: TextStyle(fontSize: 12.0),
                    //     ),
                    //     leading: const Icon(Icons.watch),
                    //     barRadius: const Radius.circular(16),
                    //     backgroundColor: Colors.grey,
                    //     progressColor: Colors.blue,
                    //   ),
                    //
//グラフ2：赤
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 150,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20.0,
                        leading: Text(model.graphStartDay),
                        trailing: Text(model.graphGoalDay),
                        percent: model.remainPeriodPercent,
                        center: Text(model.remainPeriodPercent.toString()),
                        barRadius: const Radius.circular(16),
                        progressColor: Colors.red,
                      ),
                    ),

                    //冊数progress
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 100,
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2000,
                        leading: const Icon(Icons.sunny),
                        percent: 0.9,
                        center: const Text("90.0%"),
                        barRadius: const Radius.circular(16),
                        progressColor: Colors.greenAccent,
                      ),
                    ),
//かけい部分
                    HomeCardWidget(
                      title: "おこづかい",
                      color: Colors.green[100]!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          kakeiCountArea("kakei"),
                          Center(
                            //Button_area
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: model.kakeiController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration:
                                      const InputDecoration(hintText: "金額"),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: model.kakeiNoteController,
                                  decoration:
                                      const InputDecoration(hintText: "用途"),
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => category = "食費");
                                      },
                                      child: const Text("食費"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => category = "ゆめはる");
                                      },
                                      child: const Text("ゆめはる"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => category = "学習");
                                      },
                                      child: const Text("学習"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => category = "その他");
                                      },
                                      child: const Text("その他"),
                                    ),
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
                              FocusScope.of(context).unfocus();
                              if (model.kakeiController.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Oops"),
                                      content: const Text("ちゃんと書きなさい"),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            // Navigator.of(context).pop();
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              } //if
                              await model.kakeiRegister(category);
                              model.kakeiController.clear();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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

//はる
                    HomeCardWidget(
                      title: "はる",
                      color: Colors.red[100]!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          bookCountArea("haru"),
                          Center(
                            //Button_area
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FloatingActionButton(
                                    heroTag: "hero1",
                                    child: const Icon(Icons.add),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact(); // ココ！
                                      //void call back　または　function
                                      _confettiEventHaru();
                                      // _controller.play(); // ココ！
                                      debugPrint("confetti実行");
                                      model.bookNumRegister(1, "haru");
                                    },
                                  ),
                                ),
                                ConfettiWidget(
                                  confettiController: _controllerHaru,
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
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("3"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact(); // ココ！
                                //           model.bookNumRegister(3, "haru");
                                //         },
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       width: 30,
                                //       height: 60,
                                //     ),
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("5"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact(); // ココ！
                                //           model.bookNumRegister(5, "haru");
                                //         },
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       width: 30,
                                //       height: 60,
                                //     ),
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("-1"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact();
                                //           model.bookNumRegister(-1, "haru");
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   width: double.infinity,
                                //   height: 20,
                                // ),
                              ], //children
                            ),
                          ),
                        ],
                      ),
                    ),

                    //ゆめ
                    HomeCardWidget(
                      title: "ゆめ",
                      //constの値になるかどうか、わからない  i.e.[150]とかだと、エラーが起こるだろう。
                      color: Colors.lightBlue[100]!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          bookCountArea("yume"),
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FloatingActionButton(
                                    heroTag: "hero4",
                                    child: const Icon(Icons.add),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact(); // ココ！
                                      //void call back　または　function
                                      _confettiEventYume();
                                      // _controller.play(); // ココ！
                                      debugPrint("confetti実行");
                                      model.bookNumRegister(1, "yume");
                                    },
                                  ),
                                ),
                                ConfettiWidget(
                                  confettiController: _controllerYume,
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
                                  colors: const <Color>[
                                    // 紙吹雪の色指定
                                    Colors.red,
                                    Colors.blue,
                                    //最初Colorsでなく、Constants、となっていた。
                                    Colors.green,
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                  height: 20,
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("3"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact(); // ココ！
                                //           model.bookNumRegister(3, "yume");
                                //         },
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       width: 30,
                                //       height: 60,
                                //     ),
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("5"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact(); // ココ！
                                //           model.bookNumRegister(5, "yume");
                                //         },
                                //       ),
                                //     ),
                                //     const SizedBox(
                                //       width: 30,
                                //       height: 60,
                                //     ),
                                //     SizedBox(
                                //       width: 60,
                                //       height: 60,
                                //       child: ElevatedButton(
                                //         child: const Text("-1"),
                                //         style: ElevatedButton.styleFrom(
                                //           //backgroundColor,foregroundColor
                                //           backgroundColor: Colors.grey[300],
                                //           foregroundColor: Colors.purple,
                                //           textStyle: const TextStyle(
                                //             fontSize: 20,
                                //           ),
                                //         ),
                                //         onPressed: () async {
                                //           HapticFeedback.mediumImpact();
                                //           model.bookNumRegister(-1, "yume");
                                //         },
                                //       ),
                                //     ),
                                //   ],
                                // ),
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
