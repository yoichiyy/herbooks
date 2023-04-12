import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskModel extends ChangeNotifier {
//日本語訳「リストです。Todoクラスで定義した３つの変数を使います。」
  List<Todo> todoListFromModelOverDue = [];
  // List<Todo> todoListFromModelToday = [];
  // List<Todo> todoListFromModelAfterToday = [];
  bool isLoading = false;

  // Firestore のリアルタイムリスナー
  StreamSubscription<QuerySnapshot>? _overDueListener;
  StreamSubscription<QuerySnapshot>? _subscription;

//最初にユーザー情報を取得して、
//dueDateが今日のタスクがあるかどうかを判定するメソッド












  void getTodoListRealtime() async {
    // すでにリスナーが登録されている場合は、削除する
    _overDueListener?.cancel();

    final querySnapshotsOverDue = FirebaseFirestore.instance
        .collection('todoList')
        .where('user', isEqualTo: 'ぱぱ')
        .snapshots();

    _overDueListener = querySnapshotsOverDue.listen((querySnapshot) {
      final queryDocumentSnapshots = querySnapshot.docs;
      final todoList = queryDocumentSnapshots.map((doc) => Todo(doc)).toList();
      todoList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
      todoListFromModelOverDue = todoList;
      notifyListeners();
    });
  }

  void disposeRealtimeListeners() {
    _overDueListener?.cancel();
  }

  int paThanks = 0;
  int paIntelligence = 0;
  int paCare = 0;
  int paPower = 0;
  int paSkill = 0;
  int paPatience = 0;
  int paHp = 0;
  int paHpMax = 0;

  int maThanks = 0;
  int maIntelligence = 0;
  int maCare = 0;
  int maPower = 0;
  int maSkill = 0;
  int maPatience = 0;
  int maHp = 0;
  int maHpMax = 0;

  int monsterOffense = 0;
  int monsterHp = 0;
  String monsterAbility = "";
  int monsterAEffect = 0;
  String monsterName = "";
  int monsterHpMax = 0;
  String monsterId = "";

  // void _startLoading() {
  //   isLoading = true;
  //   notifyListeners();
  // }

  // void _endLoading() {
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> getUserGraph() async {
    // _startLoading();
    try {
      //pa Data
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docRefUser =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final paUserInfo = await docRefUser.get();
      paThanks = paUserInfo.data()!["thanks"];
      paIntelligence = paUserInfo.data()!['intelligence'] as int;
      paCare = paUserInfo.data()!['care'] as int;
      paPower = paUserInfo.data()!['power'] as int;
      paSkill = paUserInfo.data()!['skill'] as int;
      paPatience = paUserInfo.data()!['patience'] as int;
      paHp = paUserInfo.data()!['hp'] as int;
      paHpMax = paUserInfo.data()!['maxhp'] as int;

      //ma Data
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
      maHp = maUserInfo.data()!['hp'] as int;
      maHpMax = maUserInfo.data()!['maxhp'] as int;

      //monster Data
      final monsterInfo = await FirebaseFirestore.instance
          .collection('monsters')
          .doc("1slime")
          .get();
      monsterOffense = monsterInfo.data()!['offense'] as int;
      monsterHp = monsterInfo.data()!['hp'] as int;
      monsterAbility = monsterInfo.data()!['ability'] as String;
      monsterAEffect = monsterInfo.data()!['a_effect'] as int;
      monsterName = monsterInfo.data()!['name'] as String;
      monsterHpMax = monsterInfo.data()!['maxhp'] as int;
      monsterId = monsterInfo.id;
    } finally {
      //失敗しても、絶対これは呼ばれる。
      // _endLoading();
    }
  } //getUserGraph

  Future<void> updateAndRepeatTask(String docId) async {
    //それぞれのdocRef取得（docRef VER）
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final userInfo = await docRefUser.get();
    final docRefMonster =
        FirebaseFirestore.instance.collection('monsters').doc("1slime");
    final monsterInfo = await docRefMonster.get();

    //1.タスクの方スタート
    final docRefTask =
        FirebaseFirestore.instance.collection('todoList').doc(docId);

    //タスク情報取得
    final taskInfo = await docRefTask.get();
    final dueDate = taskInfo.data()!["dueDate"] as Timestamp;

    //タスク処理＆UP
    final dueDateUpdated = dueDate.toDate().add(const Duration(days: 1));
    final dueDateAsTimeStamp = Timestamp.fromDate(dueDateUpdated);
    await docRefTask.update({
      "dueDate": dueDateAsTimeStamp,
    });

    //2.ユーザーの処理スタート
    //加算前ユーザー情報取得
    final intelligence = userInfo.data()!["intelligence"] as int;
    final care = userInfo.data()!["care"] as int;
    final power = userInfo.data()!["power"] as int;
    final skill = userInfo.data()!["skill"] as int;
    final patience = userInfo.data()!["patience"] as int;
    final thanks = userInfo.data()!["thanks"] as int;

    //PLUS用タスク情報取得
    final intelligenceToAdd = taskInfo.data()!["intelligence"] as int;
    final careToAdd = taskInfo.data()!["care"] as int;
    final powerToAdd = taskInfo.data()!["power"] as int;
    final skillToAdd = taskInfo.data()!["skill"] as int;
    final patienceToAdd = taskInfo.data()!["patience"] as int;
    final thanksToAdd = taskInfo.data()!["thanks"] as int;

    //PLUS処理＆UP
    final intelligenceUpdated = intelligence + intelligenceToAdd;
    final careUpdated = care + careToAdd;
    final powerUpdated = power + powerToAdd;
    final skillUpdated = skill + skillToAdd;
    final patienceUpdated = patience + patienceToAdd;
    final thanksUpdated = thanks + thanksToAdd;

    await docRefUser.update({
      'intelligence': intelligenceUpdated,
      'care': careUpdated,
      'power': powerUpdated,
      'skill': skillUpdated,
      'patience': patienceUpdated,
      'thanks': thanksUpdated,
    });

    //3.monsterへの攻撃
    //加算前情報取得
    final monsterHp = monsterInfo.data()!["hp"] as int;

    //PLUS用情報取得
    // final damageToMonster =  とりあえずTASKのTHANKSPOINT（thanksToAdd）にしておく。

    //PLUS処理＆UP
    final monsterHpUpdated = monsterHp - thanksToAdd;

    await docRefMonster.update({
      'hp': monsterHpUpdated,
    });
    //
    notifyListeners();
  }

  Future<void> updateAndDeleteTask(String docId) async {
    //それぞれのdocRef取得（docRef VER）
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final userInfo = await docRefUser.get();
    final docRefMonster =
        FirebaseFirestore.instance.collection('monsters').doc("1slime");
    final monsterInfo = await docRefMonster.get();

    //1.タスクの方スタート
    final docRefTask =
        FirebaseFirestore.instance.collection('todoList').doc(docId);

    //タスク情報取得
    final taskInfo = await docRefTask.get();
    final dueDate = taskInfo.data()!["dueDate"] as Timestamp;

    //タスク処理＆UP
    final dueDateUpdated = dueDate.toDate().add(const Duration(days: 1));
    final dueDateAsTimeStamp = Timestamp.fromDate(dueDateUpdated);
    await docRefTask.update({
      "dueDate": dueDateAsTimeStamp,
    });

    //2.ユーザーの処理スタート
    //加算前ユーザー情報取得
    final intelligence = userInfo.data()!["intelligence"] as int;
    final care = userInfo.data()!["care"] as int;
    final power = userInfo.data()!["power"] as int;
    final skill = userInfo.data()!["skill"] as int;
    final patience = userInfo.data()!["patience"] as int;
    final thanks = userInfo.data()!["thanks"] as int;

    //PLUS用タスク情報取得
    final intelligenceToAdd = taskInfo.data()!["intelligence"] as int;
    final careToAdd = taskInfo.data()!["care"] as int;
    final powerToAdd = taskInfo.data()!["power"] as int;
    final skillToAdd = taskInfo.data()!["skill"] as int;
    final patienceToAdd = taskInfo.data()!["patience"] as int;
    final thanksToAdd = taskInfo.data()!["thanks"] as int;

    //PLUS処理＆UP
    final intelligenceUpdated = intelligence + intelligenceToAdd;
    final careUpdated = care + careToAdd;
    final powerUpdated = power + powerToAdd;
    final skillUpdated = skill + skillToAdd;
    final patienceUpdated = patience + patienceToAdd;
    final thanksUpdated = thanks + thanksToAdd;

    await docRefUser.update({
      'intelligence': intelligenceUpdated,
      'care': careUpdated,
      'power': powerUpdated,
      'skill': skillUpdated,
      'patience': patienceUpdated,
      'thanks': thanksUpdated,
    });

    //3.monsterへの攻撃
    //加算前情報取得
    final monsterHp = monsterInfo.data()!["hp"] as int;

    //PLUS用情報取得
    // final damageToMonster =  とりあえずTASKのTHANKSPOINT（thanksToAdd）にしておく。

    //PLUS処理＆UP
    final monsterHpUpdated = monsterHp - thanksToAdd;

    await docRefMonster.update({
      'hp': monsterHpUpdated,
    });

    await docRefTask.delete();

    notifyListeners();
  }

  Future<void> monsterAttack(String docId) async {
    //それぞれのdocRef取得（docRef VER）
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final userInfo = await docRefUser.get();
    final docRefMonster =
        FirebaseFirestore.instance.collection('monsters').doc("1slime");
    final monsterInfo = await docRefMonster.get();

    //2.ユーザーの処理スタート
    //攻撃される前のユーザー情報取得
    final hpBefore = userInfo.data()!["hp"] as int;
    //ダメージto be added
    final damageToUser = monsterInfo.data()!["offense"] as int;
    //UPDATE情報 → UPする
    final hpUpdated = hpBefore - damageToUser;
    await docRefUser.update({
      'hp': hpUpdated,
    });
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
  String user = "";

  factory Todo.fromfirestore(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return Todo(documentSnapshot);
  }

  Todo(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // MEMO
    //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
    //コンストラクタ

    // 引数うけとるの自由に定義可能。
    // ドキュメントsnapshotがないと、todoインスタンスはっつくれない。
    // 613のは、データさえ揃っていれば、作ることができる。

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
    user = data['user'] as String;
    // total = data['total'] as int;
    id = documentSnapshot.id;
  }
}
