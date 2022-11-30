import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FabButton extends ChangeNotifier {
  final int booknum = 0;
  final String musume = "";
  //二桁必須の方法 padLeftを使いました。
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";
  final time =
      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> fabButtonFunction(booknum, musume) async {
    //userNameを取得するもっとスマートなやり方は？
    //1.doc().field('name')的に、あと一歩いけないものか？
    //2.クエリで取得するまでもない」と思うのだが、クエリを使うことはロボットにとってそんなに大きな手間ではないのか？
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = snapshot.data()!['name'];
    //     .then((DocumentSnapshot snapshot) {
    //   snapshot.get('name');
    // });

    // 日単位のカウンター登録
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
}//class