import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BattleModel extends ChangeNotifier {
  List<Battle> actionListFromBattleModel =
      []; //日本語訳？：「リストです。Todoクラスで定義した３つの変数を使います。」
  // bool isLoading = true; //本当はプライベートにして、getter setter.ぽくわける。

  // void getThankList() {
  //   final querySnapshots =
  //       FirebaseFirestore.instance.collection('thanks').snapshots();

  //   querySnapshots.listen((querySnapshot) {
  //     final queryDocumentSnapshots = querySnapshot.docs;

  //     final actionList =
  //         queryDocumentSnapshots.map((doc) => Thank(doc)).toList();
  //     actionList.sort((a, b) => b.time!.compareTo(a.time!));
  //     actionListFromBattleModel = actionList;

  //     notifyListeners();
  //   });
  // }

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

  // void _startLoading() {
  //   isLoading = true;
  //   notifyListeners();
  // }

  // void _endLoading() {
  //   isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> getUserGraph() async {
  //   _startLoading();
  //   try {
  //     final uid = FirebaseAuth.instance.currentUser!.uid;
  //     final docRefUser =
  //         FirebaseFirestore.instance.collection('users').doc(uid);
  //     final paUserInfo = await docRefUser.get();
  //     paThanks = paUserInfo.data()!["thanks"];
  //     paIntelligence = paUserInfo.data()!['intelligence'] as int;
  //     paCare = paUserInfo.data()!['care'] as int;
  //     paPower = paUserInfo.data()!['power'] as int;
  //     paSkill = paUserInfo.data()!['skill'] as int;
  //     paPatience = paUserInfo.data()!['patience'] as int;

  //     final maUserInfo = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc("NI7hic069bZSF6k2ZDOykEkJyRG2")
  //         .get();
  //     maThanks = maUserInfo.data()![
  //         "thanks"]; //ローカス変数を新規でつく・・・らないので、finalやめろ。このクラスで使ったやつを、使うから。共有するから。になる。
  //     maIntelligence = maUserInfo.data()!['intelligence'] as int;
  //     maCare = maUserInfo.data()!['care'] as int;
  //     maPower = maUserInfo.data()!['power'] as int;
  //     maSkill = maUserInfo.data()!['skill'] as int;
  //     maPatience = maUserInfo.data()!['patience'] as int;
  //   } finally {
  //     //失敗しても、絶対これは呼ばれる。
  //     _endLoading();
  //   }
  // }
}

class Battle {
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

  Battle(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    // MEMO
    //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
    //コンストラクタ
    //ジェネリクスを使ってもよい：genelics... mapもこの概念つかってる。
    //マップの中で使ってるかたを、後から決めれる仕組み。
    //キャスト。解釈するため。前半：fireのdoc.
    //変数名から型がわかるように（複数、単数を参考に）
    //lint：静的解析をどのくらい強くするか
    // final data = documentSnapshot.data() as Map<String, dynamic>;
    // taskNameOfTodoClass = data["title"] as String;
    // dueDate = (data['dueDate'] as Timestamp?)?.toDate();
    // repeatOption = data['repeatOption'] as bool;
    // intelligence = data['intelligence'] as int;
    // care = data['care'] as int;
    // power = data['power'] as int;
    // skill = data['skill'] as int;
    // patience = data['patience'] as int;
    // thanks = data['thanks'] as int;
    // user = data['user'] as String;
    // // total = data['total'] as int;
    // id = documentSnapshot.id;
  }
}
