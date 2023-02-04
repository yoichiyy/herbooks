import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      todoList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
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

class Todo {
  String taskNameOfTodoClass = ""; //クラスが所持している変数
  String id = "";
  DateTime? dueDate;
  Todo(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // MEMO
    //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
    //コンストラクタ
    //ジェネリクスを使ってもよい：genelics... mapもこの概念つかってる。
    //マップの中で使ってるかたを、後から決めれる仕組み。
    //キャスト。解釈するため。前半：fireのdoc.
    //変数名から型がわかるように（複数、単数を参考に）
    //lint：静的解析をどのくらい強くするか
    final data = documentSnapshot.data() as Map<String, dynamic>;
    taskNameOfTodoClass = data["title"] as String;
    dueDate = (data['dueDate'] as Timestamp?)?.toDate(); //null aware operator
    id = documentSnapshot.id;
  }
}
