import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String taskNameOfTodoClass = ""; //クラスが所持している変数
  String dueDate = "";
  String dueTime = "";
  String id = "";
  DateTime? createdAt;
  //https://flutter.ctrnost.com/basic/interactive/form/datapicker/

  //コンストラクタ
  Todo(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    //ジェネリクスを使ってもよい：genelics... mapもこの概念つかってる。
    //マップの中で使ってるかたを、後から決めれる仕組み。
    final data = documentSnapshot.data() as Map<String, dynamic>;
    //キャスト。解釈するため。前半：fireのdoc.
    //変数名から型がわかるように（複数、単数を参考に）

    //lint：静的解析をどのくらい強くするか
    taskNameOfTodoClass = data["title"] as String;

    createdAt =
        (data['createdAt'] as Timestamp?)?.toDate(); //null aware operator
    id = documentSnapshot.id;
  }
}
