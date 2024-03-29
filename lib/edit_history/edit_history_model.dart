import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';
import 'package:flutter/material.dart';

import '../counter_history/history_model.dart';

class EditHistoryModel extends ChangeNotifier {
  final History history;
  final bookNumController = TextEditingController();
  // final bookDateController = TextEditingController();
  // final dateStringController = TextEditingController();
  int? bookNumForEditpage;
  String? bookDateForEditpage;
  String? dateStringForEditpage;

  EditHistoryModel(this.history) {
    //テキストフィールドに、該当データを表示させる
    bookNumController.text = history.count.toString();
    // bookDateController.text = history.date;
    // dateStringController.text = history.dateString.toString();
  }

  bool isUpdatedBookNum() {
    return bookNumForEditpage != null;
    // ||history.count != null;
  }

  Future<void> update(DateTime _pickedDate) async {
    bookNumForEditpage = int.parse(bookNumController.text);
    dateStringForEditpage =
        "${_pickedDate.month}/${_pickedDate.day}(${_pickedDate.japaneseWeekday})";
    bookDateForEditpage =
        "${_pickedDate.year}${_pickedDate.month.toString().padLeft(2, "0")}${_pickedDate.day.toString().padLeft(2, "0")}";
    await FirebaseFirestore.instance
        .collection('newCount')
        .doc(history.id)
        .update({
      'date': bookDateForEditpage,
      'count': bookNumForEditpage,
      'time': dateStringForEditpage,
    });

    notifyListeners();
  }
}
