import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NumCountModel extends ChangeNotifier {
  final booknum = 0;
  final musume = "";
  //二桁必須の方法 padLeftを使いました。
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final time =
      "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final kakeiController = TextEditingController();
  final kakeiNoteController = TextEditingController();

//家計の方
  Future<void> kakeiRegister(category) async {
    int? amount = int.parse(kakeiController.text);
    String? note = kakeiNoteController.text;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userName = snapshot.data()!['name'];

    await FirebaseFirestore.instance.collection('kakei').doc().set({
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

//絵本の方
  Future<void> bookNumRegister(booknum, musume) async {
    //userNameを取得するもっとスマートなやり方は？
    //1.doc().field('name')的に、あと一歩いけないものか？
    //2.クエリで取得するまでもない」と思うのだが、クエリを使うことはロボットにとってそんなに大きな手間ではないのか？
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

    notifyListeners();
  } //fabButtonFunction
} //class
