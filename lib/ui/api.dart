import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class APIS {
  static Future<void> addToSheet(
      String amount, String category, String note) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = snapshot.data()!['name'] as String;

    //WEBデプロイしたURL
    String _url =
        "https://script.google.com/macros/s/AKfycbzpVwqskwWb3qxJxVva3mQ7qztrQ-WgRZsNfv0hXyXwn3U8-tRIvOCbmuZxYKNx6uZGvg/exec";

    // //スプレッドシート
    // https://docs.google.com/spreadsheets/d/1sByIb872RedVQjnWZZR6C8IlHKp6ujmXzYDWFPyz0iE/edit#gid=1174254070
    // //スクリプト
    // https://script.google.com/home/projects/1d2Ky3fnyfbVn_CEZpWDSNz4pXSLOxCydhs7XpqgF-azqOSMAHAxh75wP/edit

    // try {
    //   debugPrint("start submitting the form");
    final body = {
      'amount': amount,
      'category': category,
      'date': dateString,
      'note': note,
      'user': user,
    };
    // debugPrint("Json Succeeded:$body");

    //post リソース（≒データ）を作成するようなリクエスト
    // http.Response response =
    await http.post(
      Uri.parse(_url),
      body: body,
      headers: <String, String>{
        //リクエストに関するメタ情報
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    //   debugPrint(response.body);
    //   debugPrint("http succeeded");
    // } catch (e) {
    //   debugPrint(e.toString());
    // }
  }
}
