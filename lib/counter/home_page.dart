import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:counter/battle/battle_page.dart';
import 'package:counter/counter/home_card_book.dart';
import 'package:counter/counter/home_card_kakei.dart';
import 'package:counter/counter/home_card_thank.dart';
import 'package:counter/counter/num_count.dart';
import 'package:counter/ui/api.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../user/goal_setting_page.dart';

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
  final _controllerHuhu =
      ConfettiController(duration: const Duration(milliseconds: 500));

  // DateTime _pickedDate = DateTime.now();

  int _tempCounterYume = 0;
  void incrementTempCounterYume() {
    setState(() {
      _tempCounterYume++;
    });
  }

  int _tempCounterHaru = 0;
  void incrementTempCounterHaru() {
    setState(() {
      _tempCounterHaru++;
    });
  }

  int _tempCounterHuhu = 0;
  void incrementTempCounterHuhu() {
    setState(() {
      _tempCounterHuhu++;
    });
  }

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
      _controllerHaru.play();
    });
  }

  void _confettiEventYume() {
    setState(() {
      _controllerYume.play();
    });
  }

  void _confettiEventHuhu() {
    setState(() {
      _controllerHuhu.play();
    });
  }

  @override
  void dispose() {
    _controllerHaru.dispose(); // controllerを破棄する
    _controllerYume.dispose(); // controllerを破棄する
    _controllerHuhu.dispose(); // controllerを破棄する
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<NumCountModel>(
        create: (_) => NumCountModel()..getGraphData(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Ehon"),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: OutlinedButton(
                  child: Image.asset('images/character_cthulhu_shoggoth.png'),
                  onPressed: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BattlePage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: OutlinedButton(
                    child:
                        const Text('設定', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await Navigator.push<void>(
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
                      //かけい部分
                      HomeCardWidgetKakei(
                        title: "おこづかい",
                        color: Colors.green[100]!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // kakeiCountArea("kakei"),
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
                                    width: 10,
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: model.kakeiNoteController,
                                    decoration:
                                        const InputDecoration(hintText: "メモ"),
                                  ),
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 20,
                            ),

                            //GridView カテゴリー選択
                            GridView.builder(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, //カラム数
                                mainAxisSpacing: 4, //セル同士の隙間
                                crossAxisSpacing: 8,
                                childAspectRatio: 3,
                              ),
                              itemCount: 15, //要素数

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
                                                fontSize: 12),
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
                                            size: 20,
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
                                      setState(
                                          () => category = categoryList[index]);
                                    }
                                  },
                                );
                              },

                              shrinkWrap: true,
                            ),

                            //登録ボタン
                            MaterialButton(
                              color: Colors.lightBlue.shade900,
                              onPressed: () async {
                                HapticFeedback.mediumImpact(); // バイブレーション
                                FocusScope.of(context).unfocus();
                                if (model.kakeiController.text.isEmpty ||
                                    category.isEmpty) {
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
                                await Future.wait([
                                  model.kakeiRegister(category),
                                  APIS.addToSheet(model.kakeiController.text,
                                      category, model.kakeiNoteController.text),
                                ]);
                                setState(() {
                                  model.kakeiController.clear();
                                  model.kakeiNoteController.clear();
                                  checkedList.clear();
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text('おめでとうございます。'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(milliseconds: 400),
                                  margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height /
                                                  2 -
                                              50),
                                ));
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
                      HomeCardWidgetBook(
                        title: "はるTODAY: ",
                        musume: "haru",
                        color: Colors.red[100]!,
                        buttonWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: FloatingActionButton(
                                          heroTag: "hero1",
                                          child: const Icon(Icons.add),
                                          onPressed: () {
                                            incrementTempCounterHaru();
                                            HapticFeedback
                                                .mediumImpact(); // バイブレーション
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
                                        minBlastForce:
                                            5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
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
                                    ], //children
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$_tempCounterHaru',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < _tempCounterHaru;
                                          i++) //flutter コレクションフォー　で検索せよ
                                        // if (i == 1) //コレクションいふ。以上は、mapでもできる。
                                        const Icon(
                                          Icons.android,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //ゆめ
                      HomeCardWidgetBook(
                        title: "ゆめTODAY: ",
                        musume: "yume",
                        color: Colors.lightBlue[100]!,
                        buttonWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // bookCountArea("yume"),
                            Center(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,//効かぬ
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: FloatingActionButton(
                                          heroTag: "hero4",
                                          child: const Icon(Icons.add),
                                          onPressed: () {
                                            incrementTempCounterYume();
                                            HapticFeedback
                                                .mediumImpact(); // ココ！
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
                                        minBlastForce:
                                            5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
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
                                        width: 20,
                                        height: 20,
                                      ),
                                    ], //children
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$_tempCounterYume',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < _tempCounterYume;
                                          i++) //flutter コレクションフォー　で検索せよ
                                        // if (i == 1) //コレクションいふ。以上は、mapでもできる。
                                        const Icon(
                                          Icons.baby_changing_station,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //THANK
                      HomeCardThank(
                        title: "ありがとうTODAY: ",
                        musume: "huhu",
                        color: Colors.yellow[100]!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: model.thankNoteController,
                                    decoration: const InputDecoration(
                                        hintText: "thank for what"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buttonWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // bookCountArea("yume"),
                            Center(
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,//効かぬ
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: FloatingActionButton(
                                          heroTag: "hero5",
                                          child: const Icon(Icons.savings),
                                          onPressed: () {
                                            if (model.thankNoteController.text
                                                .isEmpty) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Oops"),
                                                    content: const Text(
                                                        "thank for WHAT?"),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              return;
                                            }

                                            incrementTempCounterHuhu();
                                            HapticFeedback
                                                .mediumImpact(); // ココ！
                                            //void call back　または　function
                                            _confettiEventHuhu();
                                            // _controller.play(); // ココ！
                                            model.thankRegister();
                                            setState(() {
                                              model.thankNoteController.clear();
                                            });
                                          },
                                        ),
                                      ),
                                      ConfettiWidget(
                                        confettiController: _controllerHuhu,
                                        blastDirectionality:
                                            BlastDirectionality.explosive,
                                        blastDirection: pi / 2,
                                        // 紙吹雪を出す方向(この場合画面上に向けて発射)
                                        emissionFrequency:
                                            0.9, // 発射頻度(数が小さいほど紙と紙の間隔が狭くなる)
                                        minBlastForce:
                                            5, // 紙吹雪の出る瞬間の5フレーム分の速度の最小
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
                                        width: 20,
                                        height: 20,
                                      ),
                                    ], //children
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  Text(
                                    '$_tempCounterHuhu',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  //   ],
                                  // ),
                                  const SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0;
                                          i < _tempCounterHuhu;
                                          i++) //flutter コレクションフォー　で検索せよ
                                        // if (i == 1) //コレクションいふ。以上は、mapでもできる。
                                        const Icon(
                                          Icons.savings,
                                        )
                                    ],
                                  ),
                                ],
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
