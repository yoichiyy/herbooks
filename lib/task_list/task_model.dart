import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskModel extends ChangeNotifier {
  List<Todo> todoListFromModel = []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」
  List<Thank> thankListFromModel = [];

  void getThankList() {
    final querySnapshots =
        FirebaseFirestore.instance.collection('thanks').snapshots();

    querySnapshots.listen((querySnapshot) {
      final queryDocumentSnapshots = querySnapshot.docs;

      final thankList =
          queryDocumentSnapshots.map((doc) => Thank(doc)).toList();
      thankList.sort((a, b) => a.time!.compareTo(b.time!));
      thankListFromModel = thankList;

      notifyListeners();
    });
  }

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

  int paThanks = 0;
  int paIntelligence = 0;
  int paCare = 0;
  int paPower = 0;
  int paSkill = 0;
  int paPatience = 0;

  int maThanks = 0;
  int maIntelligence = 0;
  int maCare = 0;
  int maPower = 0;
  int maSkill = 0;
  int maPatience = 0;

  Future<void> getUserGraph() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final paUserInfo = await docRefUser.get();
    paThanks = paUserInfo.data()!["thanks"];
    paIntelligence = paUserInfo.data()!['intelligence'] as int;
    paCare = paUserInfo.data()!['care'] as int;
    paPower = paUserInfo.data()!['power'] as int;
    paSkill = paUserInfo.data()!['skill'] as int;
    paPatience = paUserInfo.data()!['patience'] as int;

    final maUserInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc("NI7hic069bZSF6k2ZDOykEkJyRG2")
        .get();
    maThanks = maUserInfo.data()![
        "thanks"]; //ローカス変数を新規でつく・・・らないので、finalやめろ。このクラスで使ったやつを、使うから。共有するから。になる。
    maIntelligence = maUserInfo.data()!['intelligence'] as int;
    maCare = maUserInfo.data()!['care'] as int;
    maPower = maUserInfo.data()!['power'] as int;
    maSkill = maUserInfo.data()!['skill'] as int;
    maPatience = maUserInfo.data()!['patience'] as int;

    notifyListeners();
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

class Thank {
  DateTime? time;
  String to = "";
  String note = "";

  Thank(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;

    time = (data['time'] as Timestamp?)?.toDate();
    to = data["to"] as String;
    note = data["note"] as String;
  }
}
