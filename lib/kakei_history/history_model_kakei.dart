import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KakeiHistoryModel extends ChangeNotifier {
  List<KakeiHistory> kakeiHistoryList = [];

  Future<void> fetchKakeiHistory() async {
    final snapShotKakei = await FirebaseFirestore.instance
        .collection('kakei')
        // .where('month', isEqualTo: month)
        .get();
    final readingHistory =
        snapShotKakei.docs.map((doc) => KakeiHistory(doc)).toList();
    readingHistory.sort((a, b) => b.date.compareTo(a.date));
    kakeiHistoryList = readingHistory;

    notifyListeners();
  }
}

class KakeiHistory {
  String id = "";
  int amount = 0;
  String category = "";
  String date = "";
  String month = "";
  String note = "";
  String user = "";

  KakeiHistory(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    amount = documentSnapshot['amount'];
    category = documentSnapshot['category'];
    date = documentSnapshot['date'];
    month = documentSnapshot['month'];
    note = documentSnapshot['note'];
    user = documentSnapshot['user'];
  }
}
