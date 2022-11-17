import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryModel extends ChangeNotifier {
  List<History> historyList = [];
  List<History> userList = [];

  void reload() {
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    final docs = await FirebaseFirestore.instance.collection('newCount').get();
    final readingHistory = docs.docs.map((doc) => History(doc)).toList();
    readingHistory.sort((a, b) => b.id.compareTo(a.id));
    historyList = readingHistory;

    // final users = await FirebaseFirestore.instance.collection('users').get();
    // final readingUsers = users.docs.map((doc) => History(doc)).toList();
    // userList = readingUsers;

    notifyListeners();
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
