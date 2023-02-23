// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BattleModel extends ChangeNotifier {
//   List<Todo> actionListFromBattleModel = []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」
//   bool isLoading = true; //本当はプライベートにして、getter setter.ぽくわける。

//   void getThankList() {
//     final querySnapshots =
//         FirebaseFirestore.instance.collection('thanks').snapshots();

//     querySnapshots.listen((querySnapshot) {
//       final queryDocumentSnapshots = querySnapshot.docs;

//       final actionList =
//           queryDocumentSnapshots.map((doc) => Thank(doc)).toList();
//       actionList.sort((a, b) => b.time!.compareTo(a.time!));
//       actionListFromBattleModel = actionList;

//       notifyListeners();
//     });
//   }

//   void getTodoListRealtime() {
//     final querySnapshots =
//         FirebaseFirestore.instance.collection('todoList').snapshots();

//     //↑は、collectionをまるっと。↓は、データ４つ、かな？
//     //F質問：querySnapshotsはコレクション全体で、下のqueryDocumentSnapshotsも、docs、と書いてあるので、同じくデータ４つのように見える。
//     querySnapshots.listen((querySnapshot) {
//       //future型の"いとこ"→stream型。listenで、
//       final queryDocumentSnapshots = querySnapshot.docs; //コレクション内のドキュメント全部

//       //Todoクラスのコンストラクタに、idも追加した。これでTodo(doc)をリスト変換したtodoListには、idという変数もできました。
//       final todoList = queryDocumentSnapshots.map((doc) => Todo(doc)).toList();

//       //並べ替えて、最後にリストをtodoListというリストの箱に詰め替えてる
//       todoList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
//       todoListFromModel = todoList;

//       notifyListeners();
//     });
//   }

//   int monsterOffense = 0;
//   int monsterDefense = 0;
//   int monsterSubayasa = 0;
//   int monsterHp = 0;

//   void _startLoading() {
//     isLoading = true;
//     notifyListeners();
//   }

//   void _endLoading() {
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> getMonsterInfo() async {
//     _startLoading();
//     try {
//       final docRefMonsters =
//           FirebaseFirestore.instance.collection('monsters').doc("1slime");
//       final monsterInfo = await docRefMonsters.get();
//       monsterOffense = monsterInfo.data()!["offense"] as int;
//       monsterDefense = monsterInfo.data()!['defense'] as int;
//       monsterSubayasa = monsterInfo.data()!['subayasa'] as int;
//       monsterHp = monsterInfo.data()!['hp'] as int;

//     } finally {
//       //失敗しても、絶対これは呼ばれる。
//       _endLoading();
//     }
//   }
// }

// class Battle {
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

//   Battle(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
//     // MEMO
//     //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
//     //コンストラクタ
//     //ジェネリクスを使ってもよい：genelics... mapもこの概念つかってる。
//     //マップの中で使ってるかたを、後から決めれる仕組み。
//     //キャスト。解釈するため。前半：fireのdoc.
//     //変数名から型がわかるように（複数、単数を参考に）
//     //lint：静的解析をどのくらい強くするか
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

