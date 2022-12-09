import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../counter_history/history_model.dart';

class EditHistoryModel extends ChangeNotifier {
  final History history;
  final bookNumController = TextEditingController();
  final bookDateController = TextEditingController();
  int? bookNumForEditpage;

  EditHistoryModel(this.history) {
    //テキストフィールドに、該当データを表示させる
    bookNumController.text = history.count.toString();
    bookDateController.text = history.dateString.toString();
  }



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
