// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:counter/task_edit/edit_task.dart';
// import 'package:counter/task_list/thank_list.dart';
// import 'package:counter/ui/bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../task_edit/create_task.dart';
// import 'task_model.dart';

// class TaskListPage extends StatefulWidget {
//   const TaskListPage({super.key});

//   @override
//   State<TaskListPage> createState() => _TaskListPageState();
// }

// class _TaskListPageState extends State<TaskListPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<TaskModel>().getTodoListRealtime();
//   }

//   final player = AudioPlayer();

//   //ADVICE dispose×factory×lateの話
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BottomBar(currentIndex: 0),
//       appBar: AppBar(
//         title: const Text('やること'),
//         actions: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             child: OutlinedButton(
//               child:
//                   const Text('THANKS', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 await Navigator.push<void>(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ThankList(),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//       body: Consumer<TaskModel>(
//         builder: (context, model, child) {
//           // model.getTodoListRealtime();
//           // model.getUserGraph();

//           final todoListOverDue = model.todoListFromModelOverDue;
//           // final todoListToday = model.todoListFromModelToday;
//           // final todoListAfterToday = model.todoListFromModelAfterToday;

//           return model.isLoading
//               ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const Padding(
//                       //monster Graph
//                       padding: EdgeInsets.all(15.0),
//                       // child: StreamBuilder<Object>(
//                       //     //TODO:ここ、次のTODOどうにかしないと。
//                       //     //ここモンスタークラスにする
//                       //     stream: null,
//                       //     //repositoryパターン。外部のデータにアクセスするとき。firestoreとか。レポジトリ層
//                       //     builder: (context, snapshot) {
//                       //       // return LinearPercentIndicator(
//                       //       //   width: MediaQuery.of(context).size.width - 100,
//                       //       //   lineHeight: 20.0,
//                       //       //   percent: model.monsterHp / model.monsterHpMax,
//                       //       //   center: Text(
//                       //       //     "HP:${model.monsterHp.toString()}",
//                       //       //     style: const TextStyle(fontSize: 12.0),
//                       //       //   ),
//                       //       //   animation: true,
//                       //       //   animationDuration: 1000,
//                       //       //   leading: SizedBox(
//                       //       //     width: 20,
//                       //       //     height: 20,
//                       //       //     child: Image.asset('images/shoggoth.png'),
//                       //       //   ),
//                       //       //   barRadius: const Radius.circular(16),
//                       //       //   backgroundColor: Colors.grey,
//                       //       //   progressColor: Colors.blue[200],
//                       //       // );
//                       //     }),
//                     ),
//                     GestureDetector(
//                       //monsterのステートフルを作る。
//                       onTap: () async {
//                         await player.setSource(AssetSource('sword.mp3'));
//                         debugPrint("なってるはず");
//                       },
//                       child: SizedBox(
//                         //Monster Pic
//                         height: 150,
//                         width: 150,
//                         child: Image.asset('images/shoggoth.png'),
//                       ),
//                     ),
//                     // Padding(
//                     //   padding: const EdgeInsets.all(15.0),
//                     //   child: LinearPercentIndicator(
//                     //     width: MediaQuery.of(context).size.width - 100,
//                     //     lineHeight: 20.0,
//                     //     percent: model.paHp / model.paHpMax,
//                     //     center: Text(
//                     //       "Pa:${model.paHp.toString()}",
//                     //       style: const TextStyle(fontSize: 12.0),
//                     //     ),
//                     //     animation: true,
//                     //     animationDuration: 1000,
//                     //     leading: const Icon(Icons.rowing_outlined),
//                     //     barRadius: const Radius.circular(16),
//                     //     backgroundColor: Colors.grey,
//                     //     progressColor: Colors.blue[200],
//                     //   ),
//                     // ),
//                     // Text(
//                     //     "知${model.paIntelligence.toString()}  心${model.paCare.toString()}  力${model.paPower.toString()}  技${model.paSkill.toString()}  忍${model.paPatience.toString()}  ♡${model.paThanks.toString()}"),
//                     // Padding(
//                     //   padding: const EdgeInsets.all(15.0),
//                     //   child: LinearPercentIndicator(
//                     //     width: MediaQuery.of(context).size.width - 100,
//                     //     lineHeight: 20.0,
//                     //     leading: const Icon(Icons.pregnant_woman_rounded),
//                     //     // trailing: const Text("右"),
//                     //     percent: model.maHp / model.maHpMax,
//                     //     center: Text(
//                     //       "Ma:${model.maHp.toString()}",
//                     //     ),
//                     //     animation: true,
//                     //     animationDuration: 1000,
//                     //     barRadius: const Radius.circular(16),
//                     //     progressColor: Colors.pink[100],
//                     //   ),
//                     // ),
//                     // Text(
//                     //     "知${model.maIntelligence.toString()}  心${model.maCare.toString()}  力${model.maPower.toString()}  技${model.maSkill.toString()}  忍${model.maPatience.toString()}  ♡${model.maThanks.toString()}"),
//                     // テスト中ListView.builder
//                     Flexible(
//                       child: CustomScrollView(slivers: [
//                         SliverToBoxAdapter(child: bar("期限切れ")),
//                         SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             childCount: 1,
//                             (context, index) {
//                               return TaskChan(todoListOverDue);
//                             },
//                           ),
//                         ),
//                         SliverToBoxAdapter(child: bar("今日")),
//                         SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             childCount: 1,
//                             (context, index) {
//                               return TaskChan(todoListToday);
//                             },
//                           ),
//                         ),
//                         SliverToBoxAdapter(child: bar("明日以降")),
//                         SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             childCount: 1,
//                             (context, index) {
//                               return TaskChan(todoListAfterToday);
//                             },
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ],
//                 );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         heroTag: "hero2",
//         child: const Icon(Icons.egg_alt),
//         onPressed: () {
//           Navigator.push<void>(context,
//               MaterialPageRoute(builder: (context) => const TaskCard()));
//         },
//       ),
//     );
//   }
// }

// class TaskChan extends StatelessWidget {
//   const TaskChan(this.listFromParent, {super.key});
//   final List<Todo> listFromParent;

//   @override
//   Widget build(BuildContext context) {
//     // final taskModel = context.watch<TaskModel>();
//     final taskModel = Provider.of<TaskModel>(context, listen: true);
//     //上は同じ意味。
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: listFromParent.length,
//           itemBuilder: (BuildContext context, int index) {
//             final todo = listFromParent[index];
//             return Dismissible(
//               key: UniqueKey(),
//               //ValueKeyを使うと、dismissed widget is still part of the treeが出てくる。UniqueKeyにすると出て来ない。TODO:
//               //dismissibleと、providerが問題に関係していると思うが、一度基礎的な部分も（それぞれの仕組み？）学び直した方がよさそう。
//               child: InkWell(
//                 onTap: () async {
//                   await Navigator.push<void>(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditTaskPage(todo),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   child: ListTile(
//                     tileColor:
//                         todo.user == "まま" ? Colors.red[50] : Colors.blue[50],
//                     title: Text(
//                         '${todo.taskNameOfTodoClass}　${todo.dueDate?.month}/${todo.dueDate?.day}  ${todo.dueDate?.hour}時'),
//                   ),
//                 ),
//               ),
//               background: Container(
//                 alignment: Alignment.centerLeft,
//                 color: Colors.green[200],
//                 child: const Padding(
//                     padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
//                     child: Icon(Icons.tag_faces, color: Colors.white)),
//               ),
//               secondaryBackground: Container(
//                 alignment: Alignment.centerRight,
//                 color: const Color.fromRGBO(244, 67, 54, 1),
//                 child: const Padding(
//                   padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
//                   child: Icon(Icons.clear, color: Colors.white),
//                 ),
//               ),
//               onDismissed: (direction) async {
//                 listFromParent.remove(todo);
//                 if (direction == DismissDirection.startToEnd) {
//                   if (todo.repeatOption) {
//                     await taskModel.updateAndRepeatTask(
//                         todo.id); //repeat Trueなら、日付＋１してタスク情報更新される
//                   } else {
//                     await taskModel
//                         .updateAndDeleteTask(todo.id); //repeat Falseなら削除される
//                   }
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(
//                   //     content: Text('モンスターに${todo.thanks}のダメージ！'),
//                   //     behavior: SnackBarBehavior.floating,
//                   //     duration: const Duration(milliseconds: 2000),
//                   //     margin: EdgeInsets.only(
//                   //         bottom: MediaQuery.of(context).size.height / 2 -
//                   //             50),
//                   //   ),
//                   // );
//                   //モンスターこうげき
//                   // await model.monsterAttack(todo.id);
//                   // ScaffoldMessenger.of(context).showSnackBar(
//                   //   SnackBar(
//                   //     content: Text('${model.monsterOffense}のダメージを受けた！'),
//                   //     behavior: SnackBarBehavior.floating,
//                   //     duration: const Duration(milliseconds: 2000),
//                   //     margin: EdgeInsets.only(
//                   //         bottom: MediaQuery.of(context).size.height / 2 -
//                   //             50),
//                   //   ),
//                   // ); //snackbar
//                   await taskModel
//                       .getUserGraph(); //ScaffoldMessengerは表示実行されるが、これは実行されなかった。
//                 } else if (direction == DismissDirection.endToStart) {
//                   // listFromParent.remove(todo); //謎のメソッド。書いた記憶がない。
//                   await deleteTask(todo.id);
//                 }
//                 // else {
//                 //   debugPrint("Nothing");
//                 // }
//               },
//             ); //dismissible
//           },
//         ),
//       ],
//     );
//   } //widget build
// }

// Future<void> deleteTask(String docId) async {
//   // ユーザー情報取得
//   await FirebaseFirestore.instance.collection('todoList').doc(docId).delete();
// }

// //Statelessをクラスを作る
// //ウィジェット名わかりやすくして。
// //ウィジェットとクラスの使い分け。クラスの方が優れている。再描画のぱふぉーまんす勉強せよ。
// Widget bar(String title) {
//   // build(),
//   return Container(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title, //共通化して、関数を利用した
//           style: const TextStyle(color: Colors.white),
//         ),
//         // TextButton(
//         //   child: const Text("+"),
//         //   onPressed: () {
//         //     Navigator.push<void>(
//         //         context, //TODO: クラスを継承していないこのBARウィジェットに、どうナビゲーターを実装？！
//         //         MaterialPageRoute(builder: (context) => const TaskCard()));
//         //   },
//         // )
//       ],
//     ),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       color: Colors.grey,
//     ),
//     constraints: const BoxConstraints.expand(height: 30),
//   );
// }
