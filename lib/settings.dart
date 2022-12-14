import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'counter/home_page.dart';

class ChallengeSetting extends StatefulWidget {
  const ChallengeSetting({Key? key}) : super(key: key);

  @override
  State<ChallengeSetting> createState() => _ChallengeSetting();
}

class _ChallengeSetting extends State<ChallengeSetting> {
  final challengePeriod = 0;
  final sassuToRead = 0;
  final goalSassuTotal = 0;
  final nowTotalSassu = 0;
  final remainSassuToRead = 0;
  final startDate = "";
  final endDate = "";

  //こういう日付の計算はどうするんだっけ
  // final challengePeriodRemaining = startDate - endDate;

  //冊数、期間、開始日
  final TextEditingController _goalSassuController = TextEditingController();
  final TextEditingController _challengePeriodController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
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
        actions: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: OutlinedButton(
                child: const Text('保存', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  Map<String, dynamic> insertObj = {
                    'id': user!.uid,
                    'sassu': _goalSassuController.text,
                    'period': _challengePeriodController.text,
                    'start_date': _startDateController,
                  };
                  try {
                    var doc = FirebaseFirestore.instance
                        .collection('goals')
                        .doc(user.uid);
                    await doc.set(insertObj);

                    //新しいコード andremoveuntilが多分正しい
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
                  } catch (e) {
                    debugPrint('-----insert error----');
                    print(e);
                  }
                },
              ))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomSpace),
                child: Column(
                  children: [
//テキストフィールドのコンテナ1
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey))),
                      child: Row(
                        // 名前
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: Text('読む絵本の数'),
                          ),
                          Flexible(
                            child: TextField(
                              autofocus: false,
                              controller: _goalSassuController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              // onChanged: (String? val) {
                              //   if (val != null && val != '') {
                              //     _editTextName = val;
                              //   }
                              // },
                            ),
                          )
                        ],
                      ),
                    ),
//テキストフィールドのコンテナ2
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey))),
                      child: Row(
                        // 自己紹介
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: Text('実施期間'),
                          ),
                          Flexible(
                            child: TextField(
                              autofocus: false,
                              controller: _startDateController,
                              maxLines: 2,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //テキストフィールドのコンテナ2
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey))),
                      child: Row(
                        // 自己紹介
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 10.0, right: 40.0),
                            child: Text('開始日'),
                          ),
                          Flexible(
                            child: TextField(
                              autofocus: false,
                              controller: _startDateController,
                              maxLines: 2,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
