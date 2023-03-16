// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class TaskMonsterModel extends ChangeNotifier {
//   List<Todo> todoList = [];
//   List<Todo> todoListForMTPage = [];

//   void getTodoListRealtime() async {
//     final querySnapshotsOverDue =
//         FirebaseFirestore.instance.collection('todoList').snapshots();

// //なんでここで、リッスンしてるのかを理解すべし。
//     querySnapshotsOverDue.listen(
//       (querySnapshot) {
//         final queryDocumentSnapshots = querySnapshot.docs; //コレクション内のドキュメント全部
//         final todoList = queryDocumentSnapshots
//             .map((doc) => Todo(doc))
//             .toList(); //Todoクラスのコンストラクタに、idも追加
//         todoList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
//         todoListForMTPage = todoList; //渡すためには、この一行が必要 （T,F）TODO:

//         notifyListeners();
//       },
//     );
//   }
// }

// class Todo {
//   String taskNameOfTodoClass = "";
//   String id = "";
//   bool repeatOption = true;
//   DateTime? dueDate;
//   int intelligence = 0;
//   int care = 0;
//   int power = 0;
//   int skill = 0;
//   int patience = 0;
//   int thanks = 0;
//   int total = 0;
//   String user = "";

//   factory Todo.fromFirestore(
//       //factoryがまだ理解できていないTODO:
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
//     return Todo(documentSnapshot);
//   }

//   Todo(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
//     final data = documentSnapshot.data() as Map<String, dynamic>;
//     taskNameOfTodoClass = data["title"] as String;
//     dueDate = (data['dueDate'] as Timestamp?)?.toDate();
//     repeatOption = data['repeatOption'] as bool;
//     intelligence = data['intelligence'] as int;
//     care = data['care'] as int;
//     power = data['power'] as int;
//     skill = data['skill'] as int;
//     patience = data['patience'] as int;
//     thanks = data['thanks'] as int;
//     user = data['user'] as String;
//     // total = data['total'] as int;
//     id = documentSnapshot.id;
//   }
// }
