import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ThankModel extends ChangeNotifier {
  List<Thank> thankListFromModel = [];
  

  void getThankList() {
    final querySnapshots =
        FirebaseFirestore.instance.collection('thanks').snapshots();

    querySnapshots.listen((querySnapshot) {
      //ここでクエリ使ってみる。まずは、「過去のタスク」を取得してみる。
      final queryDocumentSnapshots = querySnapshot.docs;

      final thankList =
          queryDocumentSnapshots.map((doc) => Thank(doc)).toList();
      thankList.sort((a, b) => b.time!.compareTo(a.time!));
      thankListFromModel = thankList;

      notifyListeners();
    });
  }
}

class Thank {
  DateTime? time;
  String to = "";
  String note = "";

  Thank(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    time = (data['time'] as Timestamp?)?.toDate();
    to = data["to"] as String;
    note = data["note"] as String;
  }
}
