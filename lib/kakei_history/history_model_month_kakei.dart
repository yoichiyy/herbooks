import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonthlyKakeiHistoryModel extends ChangeNotifier {
  List<KakeiHistoryForMonth> monthlyHistoryListKakei = [];

  Future<void> fetchMonthlyHistory() async {
    final monthlySnapShotKakei =
        await FirebaseFirestore.instance.collection('kakei').get();
    final readingHistoryKakei = monthlySnapShotKakei.docs
        .map((doc) => KakeiHistoryForMonth(doc))
        .toList();
    readingHistoryKakei.sort((a, b) => b.id.compareTo(a.id));
    monthlyHistoryListKakei = readingHistoryKakei;

    notifyListeners();
  }
}

class KakeiHistoryForMonth {
  String id = "";
  int amount = 0;
  String category = "";
  String date = "";
  String month = "";
  String note = "";
  String user = "";

  KakeiHistoryForMonth(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    amount = documentSnapshot['amount'];
    category = documentSnapshot['category'];
    date = documentSnapshot['date'];
    month = documentSnapshot['month'];
    note = documentSnapshot['note'];
    user = documentSnapshot['user'];
  }
}
