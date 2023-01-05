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
import '../goal_setting_page.dart';
import 'kakei_count_area.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day}";
  final monthlyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}";
  final totalCount = "total";
  final _controllerHaru =
      ConfettiController(duration: const Duration(milliseconds: 500));
  final _controllerYume =
      ConfettiController(duration: const Duration(milliseconds: 500));
  // DateTime _pickedDate = DateTime.now();

  String category = "";

  final List<IconData> categoryIconList = [
    Icons.dining,
    Icons.coffee,
    Icons.fastfood,
    Icons.directions_run,
    Icons.local_hospital,
    Icons.sports_kabaddi,
    Icons.currency_rupee,
    Icons.menu_book,
    Icons.local_fire_department,
    Icons.train,
    Icons.pest_control_rodent,
    Icons.bedtime,
    Icons.cottage,
    Icons.electric_bolt,
    Icons.android,
  ];

//この２つをenumに統合
  final List<String> categoryList = [
    "食事",
    "嗜好品",
    "外食",
    "健康",
    "医療",
    "衣服",
    "投資",
    "本",
    "GIVE",
    "交通",
    "日用品",
    "その他",
    "家",
    "水光熱",
    "子ども",
  ];

  //enhanced enum実装前
  int castId = 0;
  final List<int> checkedList = [];

  void _checked(int index) {
    setState(() {
      checkedList.clear();
      checkedList.add(index);
    });
  }

  void _unchecked(int index) {
    setState(() {
      checkedList.remove(index);
    });
  }

  //confetti
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
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
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
                          center: Text((model.remainPeriodPercent >= 1)
                              ? "終了！"
                              : "あと${model.remainDay.toString()}日"),
                          trailing: Text(model.graphGoalDay),
                          percent: (model.remainPeriodPercent > 1)
                              ? 1
                              : model.remainPeriodPercent,
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
                          leading: Text(model.sumDouble.toString()),
                          center: Text((model.remainPeriodPercent >= 100)
                              ? "おめでとう！"
                              : "あと${model.remainSassuToRead.toString()}冊"),
                          trailing: Text(model.goalSassu.toString()),
                          percent: (model.remainPercentToRead > 1)
                              ? 1
                              : model.remainPercentToRead,
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
                                    controller: model.kakeiCategoryController,
                                    decoration:
                                        const InputDecoration(hintText: "メモ"),
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 20,
                                  ),

                                  //GridView カテゴリー選択
                                  GridView.builder(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 4),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, //カラム数
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      childAspectRatio: 1.7,
                                    ),
                                    itemCount: 12, //要素数

                                    itemBuilder: (context, index) {
                                      final bool checked =
                                          checkedList.contains(index);
                                      return InkWell(
                                        child: checked == false
                                            ? Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  categoryList[index],
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow[200],
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  categoryIconList[index],
                                                  size: 50,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                        onTap: () {
                                          castId = index;
                                          if (checked) {
                                            _unchecked(index);
                                            category = "";
                                          } else {
                                            _checked(index);
                                            setState(() =>
                                                category = categoryList[index]);
                                          }
                                        },
                                      );
                                    },

                                    shrinkWrap: true,
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
                                if (model.kakeiController.text.isEmpty ||
                                    category.isEmpty) {
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
