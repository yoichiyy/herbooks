import 'package:counter/counter/home_card.dart';
import 'package:counter/counter/num_count.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:counter/counter/home_page.dart';
import 'package:provider/provider.dart';

class GoalSetting extends StatefulWidget {
  const GoalSetting({Key? key}) : super(key: key);

  @override
  State<GoalSetting> createState() => _GoalSetting();
}

class _GoalSetting extends State<GoalSetting> {
  //冊数関連
  final nowTotalSassu = NumCountModel().fetchSumDouble();
  int goalTotalSassu = 0;
  final TextEditingController _sassuToReadController = TextEditingController();

  //期日関連
  DateTime _startDateController = DateTime.now();
  DateTime goalDate = DateTime.now();
  final TextEditingController _challengePeriodController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return MaterialApp(
      home: ChangeNotifierProvider<NumCountModel>(
        create: (_) => NumCountModel(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ));
              },
            ),
            centerTitle: true,
            title: const Text('目標設定'),
          ),
          resizeToAvoidBottomInset: false,
          body: Consumer<NumCountModel>(
            builder: (context, model, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomSpace),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //読む絵本の数
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 10.0, right: 10.0),
                                child: Text('読む絵本の数'),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 140,
                                  child: TextField(
                                    autofocus: true,
                                    controller: _sassuToReadController,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    // decoration: const InputDecoration(
                                    //   border: InputBorder.none,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //実施期間
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 10.0, right: 10.0),
                                child: Text('実施期間（◯日）'),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 140,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textInputAction: TextInputAction.next,
                                    controller: _challengePeriodController,
                                    // decoration: const InputDecoration(
                                    //   border: InputBorder.none,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //開始日（showDatePicker）
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40.0, horizontal: 10.0),
                                child: const Text("開始日")),
                            //横幅小さいボタン
                            SizedBox(
                              width: 150,
                              child: OutlinedButton(
                                child: Text(
                                    "${_startDateController.year}-${_startDateController.month}/${_startDateController.day}"),
                                onPressed: () async {
                                  final _result = await showDatePicker(
                                    context: context,
                                    currentDate: _startDateController,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now()
                                        .subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 1 * 365),
                                    ),
                                  );
                                  setState(() {
                                    if (_result != null) {
                                      _startDateController = _result;
                                    }
                                  });
                                }, //onPress
                              ),
                            ),
                          ],
                        ),
                        //登録ボタンのコンテナ
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          // child: const Text("開始日"),
                        ),
                        //Button
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            child: const Text("登録"),
                            //ここから
                            onPressed: () async {
                              //関連数値を計算して確定
                              //冊数
                              int nowTotalSassu = await model.fetchSumDouble();
                              debugPrint(_sassuToReadController.text);
                              int goalSassuToRead =
                                  int.parse(_sassuToReadController.text);
                              int goalSassuSum =
                                  nowTotalSassu + goalSassuToRead;
                              // int remainSassuToRead =
                              //     goalTotalSassu - nowTotalSassu;
                              //期間
                              DateTime goalDate = _startDateController.add(
                                  Duration(
                                      days: int.parse(
                                          _challengePeriodController.text)));

                              User? user = FirebaseAuth.instance.currentUser;
                              Map<String, dynamic> insertObj = {
                                // 'id': user!.uid,
                                'goal_sassu_toRead': goalSassuToRead,
                                'goal_sassu_sum': goalSassuSum,
                                'goal_date': goalDate,
                                'start_date': _startDateController,
                                'user': user,
                              };
                              var doc = FirebaseFirestore.instance
                                  .collection('goals')
                                  .doc("goal");
                              await doc.update(insertObj);

                              //新しいコード andremoveuntilが多分正しい
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                              );
                            },
                            //ここまで
                            // onPressed: () async {
                            //   final _result = await showDatePicker(
                            //     context: context,
                            //     currentDate: _startDateController,
                            //     initialDate: DateTime.now(),
                            //     firstDate:
                            //         DateTime.now().subtract(const Duration(days: 30)),
                            //     lastDate: DateTime.now().add(
                            //       const Duration(days: 1 * 365),
                            //     ),
                            //   );
                            //   if (_result != null) {
                            //     _startDateController = _result;
                            //   }
                            //   setState(() {});
                            // }, //onPress
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
