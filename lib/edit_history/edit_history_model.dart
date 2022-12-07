import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../counter_history/history_model.dart';

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
    bookNumForEditpage = int.parse(bookNumController.text);

    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(history.id)
        .update({
      'count': bookNumForEditpage,
    });

    notifyListeners();
  }
}
