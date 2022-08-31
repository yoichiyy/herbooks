import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../task_list/todo_class.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo todo;
  final taskNameController = TextEditingController();
  String? taskNameForEditpage;

  EditTaskModel(this.todo) {
    taskNameController.text = todo.taskNameOfTodoClass;
  }

  void updateForFirebase(DateTime dateSelected) {
    todo.createdAt = dateSelected;
    notifyListeners();
  }

  void setTaskName(String taskName) {
    taskNameForEditpage = taskName;
    notifyListeners();
  }

  bool isUpdated() {
    return taskNameForEditpage != null || todo.createdAt != null;
  }

  Future update() async {
    taskNameForEditpage = taskNameController.text;
    await FirebaseFirestore.instance
        .collection('todoList')
        .doc(todo.id)
        .update({
      'title': taskNameForEditpage,
      'createdAt': todo.createdAt,
    });
  }
}
