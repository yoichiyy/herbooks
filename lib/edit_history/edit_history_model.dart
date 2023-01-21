import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../counter_history/history_model.dart';

class EditHistoryModel extends ChangeNotifier {
  final History history;
  final bookNumController = TextEditingController();
  final bookDateController = TextEditingController();
  int? bookNumForEditpage;
  String? bookDateForEditpage;

  EditHistoryModel(this.history) {
    //テキストフィールドに、該当データを表示させる
    bookNumController.text = history.count.toString();
    bookDateController.text = history.date;
    
  }

  bool isUpdatedBookNum() {
    return bookNumForEditpage != null;
    // ||history.count != null;
  }

  Future<void> update() async {
    bookNumForEditpage = int.parse(bookNumController.text);
    bookDateForEditpage = bookDateController.text;
    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(history.id)
        .update({
      'date': bookDateForEditpage,
      'count': bookNumForEditpage,
    });

    notifyListeners();
  }
}
