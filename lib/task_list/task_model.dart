import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<Map> getUserGraph() async {
    // TODO: 一つのドキュメントを　クエリを使って取得する方法？
    final _store = FirebaseFirestore.instance;
    var PaData = await _store
        .collection('users')
        .where('name', isEqualTo: "ぱぱぱ")
        .get();
    
    final popo = PaData.data()!["thanks"];


    //サードトライ
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final userInfo = await docRefUser.get();
    final paThanks = userInfo.data()!["thanks"];

    final docRefUserSecond = await FirebaseFirestore.instance
        .collection('users')
        .doc("NI7hic069bZSF6k2ZDOykEkJyRG2")
        .get();
    final maThanks = docRefUserSecond.data()!["thanks"];

    //TODO:　これは…どうやって、task_listに変数を渡せばよかったか…。
    notifyListeners();
    //2つの変数を返すのは、MAPを使うんだったよな。
    // return {"paThanks": paThanks, "maThanks": maThanks};
  }
}

class Todo {
  String taskNameOfTodoClass = "";
  String id = "";
  bool repeatOption = true;
  DateTime? dueDate;
  int intelligence = 0;
  int care = 0;
  int power = 0;
  int skill = 0;
  int patience = 0;
  int thanks = 0;
  int total = 0;

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
    dueDate = (data['dueDate'] as Timestamp?)?.toDate();
    repeatOption = data['repeatOption'] as bool;
    intelligence = data['intelligence'] as int;
    care = data['care'] as int;
    power = data['power'] as int;
    skill = data['skill'] as int;
    patience = data['patience'] as int;
    thanks = data['thanks'] as int;
    // total = data['total'] as int;
    id = documentSnapshot.id;
  }
}
