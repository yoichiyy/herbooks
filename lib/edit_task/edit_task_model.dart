import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/task_list/task_model.dart';
import 'package:flutter/material.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo todo;
  final taskNameController = TextEditingController();
  String? taskNameForEditpage;

  EditTaskModel(this.todo) {
    taskNameController.text = todo.taskNameOfTodoClass;
  }

  void updateForFirebase(DateTime dateSelected) {
    todo.dueDate = dateSelected;
    notifyListeners();
  }

  void setTaskName(String taskName) {
    taskNameForEditpage = taskName;
    notifyListeners();
  }

  bool isUpdated() {
    return taskNameForEditpage != null || todo.dueDate != null;
  }

  Future update() async {
    taskNameForEditpage = taskNameController.text;
    await FirebaseFirestore.instance
        .collection('todoList')
        .doc(todo.id)
        .update({
      'title': taskNameForEditpage,
      'dueDate': todo.dueDate,
      // 'taskStatus': ,
    });
  }
}
