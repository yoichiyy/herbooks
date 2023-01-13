import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/kakei_history/history_model_kakei.dart';
import 'package:flutter/material.dart';

class EditKakeiHistoryModel extends ChangeNotifier {
  final KakeiHistory kakeiHistory;
  final kakeiMonthController = TextEditingController();
  final kakeiDateController = TextEditingController();
  final amountController = TextEditingController();
  final kakeiNoteController = TextEditingController();

  String? kakeiMonthForEditPage;
  String? kakeiDateForEditPage;
  int? amountForEditPage;
  String? kakeiNoteForEditPage;

  EditKakeiHistoryModel(this.kakeiHistory) {
    //テキストフィールドに、該当データを表示させる
    kakeiMonthController.text = kakeiHistory.month;
    kakeiDateController.text = kakeiHistory.date;
    amountController.text = kakeiHistory.amount.toString();
    kakeiNoteController.text = kakeiHistory.note;
  }

  bool isUpdatedBookNum() {
    return amountForEditPage != null;
  }

  Future<void> update() async {
    kakeiMonthForEditPage = kakeiDateController.text;
    kakeiDateForEditPage = kakeiDateController.text;
    amountForEditPage = int.parse(amountController.text);
    kakeiNoteForEditPage = kakeiDateController.text;

    await FirebaseFirestore.instance
        .collection('kakei')
        .doc(kakeiHistory.id)
        .update({
      'month': kakeiMonthForEditPage,
      'date': kakeiDateForEditPage,
      'amount': amountForEditPage,
      'note': kakeiNoteForEditPage,
    });

    notifyListeners();
  }
}
