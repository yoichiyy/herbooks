import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class APIS {
  static Future<void> addToSheet(amount,category,date ,month,note ,user) async {
            //WEBデプロイしたURL
    String _url ="https://script.google.com/macros/s/AKfycbx71CsPQ45szUDVIR4R0DMP6S71VoCT6cB3HYSJTICO7qVJP-EYeU-M6G_tPH3Aw65e_Q/exec";
            // //スプレッドシート
            // https://docs.google.com/spreadsheets/d/1sByIb872RedVQjnWZZR6C8IlHKp6ujmXzYDWFPyz0iE/edit#gid=1174254070
            // //スクリプト
            // https://script.google.com/home/projects/1d2Ky3fnyfbVn_CEZpWDSNz4pXSLOxCydhs7XpqgF-azqOSMAHAxh75wP/edit
        
    try {
      // debugPrint("start submitting the form");
      Map body = {
        'amount'  :amount,
        'category':category,
        'date' :DateFormat('MM/dd').format(date),
        'note'  :note,
        'user'  :user,
      };
      // debugPrint("Json Succeeded");

      http.Response response = await http.post(
        Uri.parse(_url),
        body: body,
      );
      debugPrint(response.body);
      // debugPrint("http succeeded");

      // return (response.statusCode == 302);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
