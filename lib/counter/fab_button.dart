import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FabButton extends ChangeNotifier {
  final int booknum = 0;
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> fabButtonFunction(booknum) async {
    //日単位のカウンター登録
    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(dailyCount+uid)
        .get() 
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists)
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc(dailyCount+uid)
                    .update({"count": FieldValue.increment(booknum)})
              }
            else
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc(dailyCount+uid)
                    .set(
      {
        "date": dailyCount,
        "month": monthlyCount,
        "count": booknum,
        "user": uid,
      },
                ),
              },
          },
        ); //then

    notifyListeners();
  } //fabButtonFunction
}//class