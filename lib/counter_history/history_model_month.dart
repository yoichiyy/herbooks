import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonthlyHistoryModel extends ChangeNotifier {
  List<HistoryForMonth> monthlyHistoryListHaru = [];
  List<HistoryForMonth> monthlyHistoryListYume = [];

  Future<void> fetchMonthlyHistory() async {
    final monthlySnapShotHaru = await FirebaseFirestore.instance
        .collection('monthHistory')
        .where('musume', isEqualTo: "haru")
        .get();
    final readingHistoryHaru =
        monthlySnapShotHaru.docs.map((doc) => HistoryForMonth(doc)).toList();
    readingHistoryHaru.sort((a, b) => b.id.compareTo(a.id));
    monthlyHistoryListHaru = readingHistoryHaru;

    final monthlySnapShotYume = await FirebaseFirestore.instance
        .collection('newCount')
        .where('musume', isEqualTo: "yume")
        .get();
    final readingHistoryYume =
        monthlySnapShotYume.docs.map((doc) => HistoryForMonth(doc)).toList();
    readingHistoryYume.sort((a, b) => b.id.compareTo(a.id));
    monthlyHistoryListYume = readingHistoryYume;

    notifyListeners();
  }

}

class HistoryForMonth {
  String id = "";
  int count = 0;
  String month = "";
  String musume = "";

  HistoryForMonth(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.id;
    count = documentSnapshot['count'];
    month = documentSnapshot['month'];
    musume = documentSnapshot['musume'];
  }

}
