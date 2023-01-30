import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumCountModel extends ChangeNotifier {
  final bookNum = 0;
  final musume = "";
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
  final monthlyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}";
  final monthString = "${DateTime.now().year}年${DateTime.now().month}月";

  final time =
      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final kakeiController = TextEditingController();
  final kakeiNoteController = TextEditingController();
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
    DateTime startDate = allData.docs[0].data()['start_date'].toDate();
    graphStartDay =
        "${startDate.month}/${startDate.day}(${startDate.japaneseWeekday})";

    DateTime goalDate = allData.docs[0].data()['goal_date'].toDate();
    graphGoalDay =
        "${goalDate.month}/${goalDate.day}(${goalDate.japaneseWeekday})";
    int challengePeriod = goalDate.difference(startDate).inDays + 1;
    remainDay = goalDate.difference(DateTime.now()).inDays + 1;
    remainPeriodPercent =
        1 - ((remainDay / challengePeriod) * 100).round() / 100;
    sumDouble = await fetchSumDouble();
    goalSassu = await allData.docs[0].data()['goal_sassu_sum'];
    totalSassuToRead = await allData.docs[0].data()['goal_sassu_toRead'];
    remainSassuToRead = goalSassu - sumDouble;
    remainPercentToRead =
        1 - ((remainSassuToRead / totalSassuToRead) * 100).round() / 100;

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

  //全冊数のカウント
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
  Future<int> getCounterForMonth(String monthlyCount, String musume) async {
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
      // print(count.toString());
      // print(count.runtimeType);
      sumMonth += count;
    }
    return sumMonth;
  }

// 日の冊数カウント
  Future<int> getCounterForDay(String dailyCount, String musume) async {
//newCountにdoc検索を変えたバージョン
    final _store = FirebaseFirestore.instance;
    var dayData = await _store
        .collection('newCount')
        .where('musume', isEqualTo: musume)
        .where('date', isEqualTo: dailyCount)
        .get();

    List data = dayData.docs;
    int sumDay = 0;

    for (int i = 0; i < data.length; i++) {
      final count = (data[i].data()['count']) as int;
      // print(count.toString());
      // print(count.runtimeType);
      sumDay += count;
    }
    return sumDay;
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

  //登録メソッド家計→絵本
  Future<void> kakeiRegister(category) async {
    int? amount = int.parse(kakeiController.text);
    String? note = kakeiNoteController.text;
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

  Future<void> bookNumRegister(booknum, musume) async {
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


    // ここから、monthlyへの登録
    await FirebaseFirestore.instance
        .collection('monthHistory')
        .doc(monthlyCount + musume)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists)
              {
                FirebaseFirestore.instance
                    .collection('monthHistory')
                    .doc(monthlyCount + musume)
                    .update({"count": FieldValue.increment(booknum)})
              }
            else
              {
                FirebaseFirestore.instance
                    .collection('monthHistory')
                    .doc(monthlyCount + musume)
                    .set(
                  {
                    "monthId": monthlyCount,
                    "count": booknum,
                    "month": monthString,
                    "musume": musume,
                  },
                ),
              },
          },
        ); //then

    notifyListeners();
  }
} //class

