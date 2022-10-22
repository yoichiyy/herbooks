import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../counter/new_history_page.dart';

class EditHistoryModel extends ChangeNotifier {
  final History history;
  final bookNumController = TextEditingController();
  int? bookNumForEditpage;

  EditHistoryModel(this.history) {
    //テキストフィールドに、該当データを表示させる
    bookNumController.text = history.count.toString();
  }

  // void setCountHistory(String newCountText) {
  //   bookNumForEditpage = int.tryParse(newCountText);
  //   notifyListeners();
  //   //これはどこに、情報として伝わっている？→ググる。この編集ページのbookNumForEditPageの値が変わるだけだから、別にいらないんじゃないの？
  // }

  bool isUpdatedBookNum() {
    return bookNumForEditpage != null;
    // ||history.count != null;
  }

  Future update() async {
    //更新ボタンを押すとエラー
    //bookNumControllerを、無理くりint?にcastしようとしているのが、多分だめと言われている。
    //asを使ったキャストは、基本、しないほうがいい。

    bookNumForEditpage = int.parse(bookNumController.text);

    //try catch

    // .text
    await FirebaseFirestore.instance
        .collection('dailyCount')
        .doc(history.id)
        .update({
      'count': bookNumForEditpage,
    });
    
    notifyListeners();
  }
}
