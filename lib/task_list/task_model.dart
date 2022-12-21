import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'todo_class.dart';

class TaskModel extends ChangeNotifier {
  List<Todo> todoListFromModel = []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」

  void getTodoListRealtime() {
    final querySnapshots =
        FirebaseFirestore.instance.collection('todoList').snapshots();

    //↑は、collectionをまるっと。↓は、データ４つ、かな？
    //F質問：querySnapshotsはコレクション全体で、下のqueryDocumentSnapshotsも、docs、と書いてあるので、同じくデータ４つのように見える。
    querySnapshots.listen((querySnapshot) {
      //future型の"いとこ"→stream型。listenで、
      final queryDocumentSnapshots = querySnapshot.docs; //コレクション内のドキュメント全部

      //Todoクラスのコンストラクタに、idも追加した。これでTodo(doc)をリスト変換したtodoListには、idという変数もできました。
      final todoList = queryDocumentSnapshots.map((doc) => Todo(doc)).toList();

      //並べ替えて、最後にリストをtodoListというリストの箱に詰め替えてる
      todoList.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      todoListFromModel = todoList;

      notifyListeners();
    });
  }

// //dismissible更新中
//   Future<void> updateTaskStatusAndPlaySound(int status, audioCache) async {
//     await FirebaseFirestore.instance
//         .collection("tasks")
//         .doc(this.taskID)
//         .update(
//       {"task_status": status},
//     );

//     //undo機能
//     // taskStatusUndoButton.value = this.taskID;

//     if (status == 1) {
//       //勝利により、POINT GET
//       // await updateUserPoints(this.taskPoints);
//     }

//     newTaskInserted.value = await this.makeRepeat();
//   }

}

