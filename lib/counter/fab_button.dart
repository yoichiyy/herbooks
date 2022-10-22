import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/utils/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FabButton extends ChangeNotifier {
  final int booknum = 0;
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";
  final time =
      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> fabButtonFunction(booknum) async {
    //日単位のカウンター登録
    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(dailyCount + uid)
        .get()
        .then(
          (docSnapshot) => {
            if (docSnapshot.exists)
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc("${DateTime.now()}")
                    .update({"count": FieldValue.increment(booknum)})
              }
            else
              {
                FirebaseFirestore.instance
                    .collection('newCount')
                    .doc("${DateTime.now()}")
                    .set(
                  {
                    "date": dailyCount,
                    "month": monthlyCount,
                    "count": booknum,
                    "user": uid,
                    "time": time,
                  },
                ),
              },
          },
        ); //then

    notifyListeners();
  } //fabButtonFunction
}//class