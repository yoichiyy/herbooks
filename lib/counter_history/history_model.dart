import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../counter/num_count.dart';

class HistoryModel extends ChangeNotifier {
  List<History> historyList = [];
  List<History> historyListYume = [];
  List<History> userList = [];

  void reload() {
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    final snapShotHaru = await FirebaseFirestore.instance
        .collection('newCount')
        .where('musume', isEqualTo: "haru")
        .get();
    final readingHistory =
        snapShotHaru.docs.map((doc) => History(doc)).toList();
    readingHistory.sort((a, b) => b.date.compareTo(a.date));
    historyList = readingHistory;

    final snapShotYume = await FirebaseFirestore.instance
        .collection('newCount')
        .where('musume', isEqualTo: "yume")
        .get();
    final readingHistoryYume =
        snapShotYume.docs.map((doc) => History(doc)).toList();
    readingHistoryYume.sort((a, b) => b.date.compareTo(a.date));
    historyListYume = readingHistoryYume;
    debugPrint(historyListYume.toString());

    // final users = await FirebaseFirestore.instance.collection('users').get();
    // final readingUsers = users.docs.map((doc) => History(doc)).toList();
    // userList = readingUsers;

    notifyListeners();
  }

  final monthList = [
    "202210",
    "202211",
    "202212",
    "202301",
    "202302",
    "202303",
    "202304",
    "202305",
    "202306",
    "202307",
    "202308",
    "202309",
    "202310",
    "202311",
    "202312",
  ];

  // 【月：冊数】のMAPを作る
  Future<List<int>> fetchMapForMonths(String musume) async {
    final result = <int>[];
    for (final monthString in monthList) {
      final sassu =
          await NumCountModel().getCounterForMonth(monthString, musume);
      result.add(sassu);
    }

    return result;
  }
}

class History {
  String id = "";
  int count = 0;
  String date = "";
  String dateString = "";
  String user = "";
  String musume = "";

  // コンストラクタ = クラスのインスタンスを作成するメソッド
  // Hisotry(this.count, this.anotherParam);　位置引数。(positional)
  // History({required this.count, required this.anotherParam});//名前付き引数 named argument

  History(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    count = documentSnapshot['count'];
    date = documentSnapshot['date'];
    dateString = documentSnapshot['time'];
    user = documentSnapshot['user'];
    id = documentSnapshot.id;
    musume = documentSnapshot['musume'];
  }

  // History(DocumentSnapshot doc) {
  //   count = doc['count'];
  //   date = doc['date'];
  //   dateString = doc['date_string'];
  //   id = doc.id;
  // }
}
