import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumCountModel extends ChangeNotifier {
  final booknum = 0;
  final musume = "";
  //二桁必須の方法 padLeftを使いました。
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final time =
      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  final uid = FirebaseAuth.instance.currentUser!.uid;
  // User? user = FirebaseAuth.instance.currentUser;

  final kakeiController = TextEditingController();
  final kakeiCategoryController = TextEditingController();
  String graphStartDay = "";
  String graphGoalDay = ""; //変更されうるよ、という状態
  double remainPeriodPercent = 0;
  int remainDay = 0;
  int remainSassuToRead = 0;
  int sumDouble = 0;
  double remainPercentToRead = 0;
  int goalSassu = 0;
  int totalSassuToRead = 0;

  Future<void> getGraphData() async {
    final _store = FirebaseFirestore.instance;
    final allData = await _store.collection('goals').get();
    // where('user', isEqualTo: user).

    //日付。「今日。ゴールの。残り期間。」
    DateTime startDate = allData.docs[0].data()['start_date'].toDate();
    graphStartDay =
        "${startDate.month}/${startDate.day}(${startDate.japaneseWeekday})";

    DateTime goalDate = allData.docs[0].data()['goal_date'].toDate();
    graphGoalDay =
        "${goalDate.month}/${goalDate.day}(${goalDate.japaneseWeekday})";
    int challengePeriod = goalDate.difference(startDate).inDays;
    remainDay = goalDate.difference(DateTime.now()).inDays + 1;
    remainPeriodPercent =
        1 - ((remainDay / challengePeriod) * 100).round() / 100;

    //今と、冊数。残りと、ゴール
//今のトータル
    // int startSassu = allData.docs[0].data()['start_sassu'];
    // int totalSassuToRead = goalSassu - startSassu;
    //問題箇所
    sumDouble = await fetchSumDouble();
    //方の定義かかない→かくから、ローカルになってしまう。ローカルならfinal。
    goalSassu = await allData.docs[0].data()['goal_sassu_sum'];
    totalSassuToRead = await allData.docs[0].data()['goal_sassu_toRead'];

    remainSassuToRead = goalSassu - sumDouble;
    remainPercentToRead =
        1 - (((remainSassuToRead / totalSassuToRead) * 100).round() / 100);

    notifyListeners();

    // return {
    //   remainPercentToRead: remainPercentToRead,
    //   remainPeriodPercent: remainPeriodPercent,
    // };
  }

  Future<int> fetchSumDouble() async {
    final _store = FirebaseFirestore.instance;
    final allData = await _store.collection('newCount').get();

    List data = allData.docs;
    int sumDouble = 0;

    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['count']) as int;
      sumDouble += count;
      notifyListeners();
    }
    return sumDouble;
  }

  //　全冊数のカウント
  Future<int> fetchReadCountAll(String musume) async {
    final _store = FirebaseFirestore.instance;
    final allData = await _store
        .collection('newCount')
        .where('musume', isEqualTo: musume)
        .get();

    List data = allData.docs;
    int sumAll = 0;

    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['count']) as int;
      sumAll += count;
    }
    return sumAll;
  }

  // 月の冊数カウント
  Future<int> fetchReadCountForMonth(String monthlyCount, String musume) async {
    final _store = FirebaseFirestore.instance;
    final monthData = await _store
        .collection('newCount')
        .where('musume', isEqualTo: musume)
        .where('month', isEqualTo: monthlyCount)
        .get();

    List data = monthData.docs;
    int sumMonth = 0;

    //複数のDOCをここから合計する
    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['count']) as int;
      sumMonth += count;
    }
    return sumMonth;
  }

  // 日の冊数カウント
  Future<int> fetchReadCountForDAY(String dailyCount, String musume) async {
    //newCountにdoc検索を変えたバージョン
    final _store = FirebaseFirestore.instance;
    var dayData = await _store
        .collection('newCount')
        .where('musume', isEqualTo: musume)
        .where('date', isEqualTo: dailyCount)
        .get();

    List data = dayData.docs;
    int sumDay = 0;

    //複数のDOCをここから合計する
    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['count']) as int;
      // print(count.toString());
      // print(count.runtimeType);
      sumDay += count;
    }
    return sumDay;
  }

  // 家計の方

  Future<int> getKakeiForDay(String dailyCount, String musume) async {
    final _store = FirebaseFirestore.instance;
    var dayData = await _store
        .collection('kakei')
        .where('date', isEqualTo: dailyCount)
        .get();

    List data = dayData.docs;
    int sumDay = 0;

    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['amount']) as int;
      sumDay += count;
    }
    return sumDay;
  }

  // 家計の方
  Future<int> getKakeiForMonth(String monthlyCount, String musume) async {
    final _store = FirebaseFirestore.instance;
    final monthData = await _store
        .collection('kakei')
        .where('month', isEqualTo: monthlyCount)
        .get();

    List data = monthData.docs;
    int sumMonth = 0;

    //複数のDOCをここから合計する
    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['amount']) as int;
      sumMonth += count;
    }
    return sumMonth;
  }

  // 家計の方
  Future<int> getKakeiForAll(String oya) async {
    //新しい、newCountのコード
    //上のdailyのカウント取得との違いは、「最初にnewCountのすべて」を取得している。
    final _store = FirebaseFirestore.instance;
    final allData = await _store.collection('kakei').get();

    List data = allData.docs;
    int sumAll = 0;

    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['amount']) as int;
      sumAll += count;
    }
    return sumAll;
  }

  //[こうすけさん候補] cloud function
  //changenotifi3rのクラスをつくり、sumAllを変数に入れる。それぞれ。
  //２つのsumAllを足し算した、変数をつくる。

  //はりつけここまで

  //ここから元のコード
  //以降情報の登録。PUSH。
  //家計の方
  Future<void> kakeiRegister(category) async {
    int? amount = int.parse(kakeiController.text);
    String? note = kakeiCategoryController.text;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = snapshot.data()!['name'];

    await FirebaseFirestore.instance
        .collection('kakei')
        .doc(dailyCount + userName)
        .set({
      'amount': amount,
      "date": dailyCount,
      "month": monthlyCount,
      'note': note,
      'category': category,
      'user': userName,
      // "repeat": repeat,
    });
    notifyListeners();
  }

  //絵本の方
  Future<void> bookNumRegister(booknum, musume) async {
    //userNameを取得するもっとスマートなやり方は？
    //1.doc().field('name')的に、あと一歩いけないものか？
    //2.クエリで取得するまでもない」と思うのだが、クエリを使うことはロボットにとってそんなに大きな手間ではないのか？
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = snapshot.data()!['name'];

    //
    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(dailyCount + uid + musume)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists)
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc(dailyCount + uid + musume)
                    .update({"count": FieldValue.increment(booknum)})
              }
            else
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc(dailyCount + uid + musume)
                    .set(
                  {
                    "date": dailyCount,
                    "month": monthlyCount,
                    "count": booknum,
                    "user": userName,
                    "time": time,
                    "musume": musume,
                  },
                ),
              },
          },
        ); //then

    notifyListeners();
  } //fabButtonFunction
} //class


  //ここから　こうすけさんメモ
  //  readCount() {
  //   fetchReadCountAll(musume);
  // }
  // int sumAllHaru = 0;
  // int sumAllYume = 0;
  // bool isLoading = true; //一人目の合計値が取得できるまで、ぐるぐる

  //引数ないので、getter=(変数と関数のあいのこ)
  // int get totalSumAll => sumAllHaru + sumAllYume;
  //getterとsetter勉強ぐぐる
