import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIS {
  static Future<void> addToSheet(amount, category, note) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = snapshot.data()!['name'];

    //WEBデプロイしたURL
    String _url =
        "https://script.google.com/macros/s/AKfycbx71CsPQ45szUDVIR4R0DMP6S71VoCT6cB3HYSJTICO7qVJP-EYeU-M6G_tPH3Aw65e_Q/exec";
    // //スプレッドシート
    // https://docs.google.com/spreadsheets/d/1sByIb872RedVQjnWZZR6C8IlHKp6ujmXzYDWFPyz0iE/edit#gid=1174254070
    // //スクリプト
    // https://script.google.com/home/projects/1d2Ky3fnyfbVn_CEZpWDSNz4pXSLOxCydhs7XpqgF-azqOSMAHAxh75wP/edit

    try {
      debugPrint("start submitting the form");
      Map body = {
        'amount': amount,
        'category': category,
        'date': dateString,
        'note': note,
        'user': user,
      };
      debugPrint("Json Succeeded");

      http.Response response = await http.post(
        Uri.parse(_url),
        body: body,
      );
      debugPrint(response.body);
      debugPrint("http succeeded");

      // return (response.statusCode == 302);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
