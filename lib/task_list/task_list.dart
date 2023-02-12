import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../edit_task/create_task.dart';
import '../edit_task/edit_task.dart';
import 'task_model.dart';

class TaskListPage extends StatefulWidget {
  // final Todo todo;
  // const TaskListPage(this.todo, {Key? key}) : super(key: key);
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
// TODO:こんぶんさんADVICEそっくりやろうとしたが、どうやら話が違うようだ。
// そもそも、もう少しinitStateとかで何をしているのか、
// 仕組みをよく理解していれば、ここも自分でできたかもしれない。
// ので、もう一度ここをお聞きしたい。
// それを通じて、今回の話を理解したい。

//[VERBOSE-2:dart_vm_initializer.cc(41)] Unhandled Exception: A TaskModel was used after being disposed.
//Once you have called dispose() on a TaskModel, it can no longer be used.

// late TaskModel model;
// @override
//   void initState() {
//     model = TaskModel(widget.taskmodel);
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '絵本COUNTER_WEB版',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //
      home: ChangeNotifierProvider<TaskModel>(
        // create: (_) {
        //   final taskModel = TaskModel(); //インスタンス化して
        //   taskModel.getTodoListRealtime(); //したものを、メソッドよんで、
        //   return taskModel; //かえす。（createなので）
        // },
        create: (_) => TaskModel()..getTodoListRealtime(),
        child: Scaffold(
          bottomNavigationBar: const BottomBar(currentIndex: 0),
          appBar: AppBar(
            title: const Text('やること'),
          ),
          body: Consumer<TaskModel>(
            builder: (context, model, child) {
              final todoList = model.todoListFromModel;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 100,
                      lineHeight: 14.0,
                      percent: 0.5,
                      center: const Text(
                        "50.0%",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      leading: const Icon(Icons.watch),
                      barRadius: const Radius.circular(16),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 100,
                      animation: true,
                      animationDuration: 1000,
                      lineHeight: 20.0,
                      leading: const Icon(Icons.local_hospital_rounded),
                      // trailing: const Text("右"),
                      percent: 0.2,
                      center: const Text("20.0%"),
                      barRadius: const Radius.circular(16),
                      progressColor: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 100,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      leading: const Icon(Icons.sunny),
                      percent: 0.9,
                      center: const Text("90.0%"),
                      barRadius: const Radius.circular(16),
                      progressColor: Colors.greenAccent,
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final todo = todoList[index];
                        return Dismissible(
                          key: UniqueKey(),
                          //TODO:dismissed Dismissible widget is still part of the tree.
                          //Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.
                          //やはり、ValueKeyでは、エラーになってしまう。できれば仕組みを理解したい。
                          // key: ObjectKey(todoIndex
                          //     .id),

                          // key: ValueKey(todo
                          //     .id),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskPage(todo),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    '${todo.taskNameOfTodoClass}　${todo.dueDate?.month}/${todo.dueDate?.day}  ${todo.dueDate?.hour}時'),
                              ),
                            ),
                          ),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.green[200],
                            child: const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                                child:
                                    Icon(Icons.tag_faces, color: Colors.white)),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            color: const Color.fromRGBO(244, 67, 54, 1),
                            child: const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                              child: Icon(Icons.clear, color: Colors.white),
                            ),
                          ),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              todo.repeatOption
                                  ? updateAndRepeatTask(todo.id)
                                  : updateAndDeleteTask(todo.id);
                              //TODO:update...のあとに、続いてdeleteをやりたかったのだが、この書き方であっているのか。順番を守ってもらうためにはどうしたら良かったのか？
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              deleteTask(todo.id);
                            } else {
                              debugPrint("Nothing");
                            }
                            setState(
                              () {},
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
          // ここから
          floatingActionButton: FloatingActionButton(
            heroTag: "hero2",
            child: const Icon(Icons.egg_alt),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TaskCard()));
            },
          ),
          // ここまで
        ),
      ),
    );
  }
}

Future<void> updateAndRepeatTask(String docId) async {
  //それぞれのdocRef取得（docRef VER）
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final userInfo = await docRefUser.get();

  //タスクの方スタート
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

  //加算前ユーザー情報取得
  final intelligence = userInfo.data()!["intelligence"] as int;
  final care = userInfo.data()!["care"] as int;
  final power = userInfo.data()!["power"] as int;
  final skill = userInfo.data()!["skill"] as int;
  final patience = userInfo.data()!["patience"] as int;
  // final thanks = userInfo.data()!["thanks"] as int;
  // final total = userInfo.data()!["total"] as int;

  //PLUS用タスク情報取得
  final intelligenceToAdd = taskInfo.data()!["intelligence"] as int;
  final careToAdd = taskInfo.data()!["care"] as int;
  final powerToAdd = taskInfo.data()!["power"] as int;
  final skillToAdd = taskInfo.data()!["skill"] as int;
  final patienceToAdd = taskInfo.data()!["patience"] as int;
  // final thanksToAdd = taskInfo.data()!["thanks"] as int;
  // final totalToAdd = userInfo.data()!["total"] as int;

  //PLUS処理＆UP
  final intelligenceUpdated = intelligence + intelligenceToAdd;
  final careUpdated = care + careToAdd;
  final powerUpdated = power + powerToAdd;
  final skillUpdated = skill + skillToAdd;
  final patienceUpdated = patience + patienceToAdd;
  // final thanksUpdated = thanks + thanksToAdd;
  // final totalUpdated = total + totalToAdd;

  await docRefUser.update({
    'intelligence': intelligenceUpdated,
    'care': careUpdated,
    'power': powerUpdated,
    'skill': skillUpdated,
    'patience': patienceUpdated,
    // 'thanks': thanksUpdated,
    // 'total': totalUpdated,
  });
}

Future<void> updateAndDeleteTask(String docId) async {
  //それぞれのdocRef取得（docRef VER）
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final userInfo = await docRefUser.get();

  //タスクの方スタート
  final docRefTask =
      FirebaseFirestore.instance.collection('todoList').doc(docId);

  final taskInfo = await docRefTask.get();

  //加算前ユーザー情報取得
  final intelligence = userInfo.data()!["intelligence"] as int;
  final care = userInfo.data()!["care"] as int;
  final power = userInfo.data()!["power"] as int;
  final skill = userInfo.data()!["skill"] as int;
  final patience = userInfo.data()!["patience"] as int;
  // final thanks = userInfo.data()!["thanks"] as int;
  // final total = userInfo.data()!["total"] as int;

  //PLUS用タスク情報取得
  final intelligenceToAdd = taskInfo.data()!["intelligence"] as int;
  final careToAdd = taskInfo.data()!["care"] as int;
  final powerToAdd = taskInfo.data()!["power"] as int;
  final skillToAdd = taskInfo.data()!["skill"] as int;
  final patienceToAdd = taskInfo.data()!["patience"] as int;
  // final thanksToAdd = taskInfo.data()!["thanks"] as int;
  // final totalToAdd = userInfo.data()!["total"] as int;

  //PLUS処理＆UP
  final intelligenceUpdated = intelligence + intelligenceToAdd;
  final careUpdated = care + careToAdd;
  final powerUpdated = power + powerToAdd;
  final skillUpdated = skill + skillToAdd;
  final patienceUpdated = patience + patienceToAdd;
  // final thanksUpdated = thanks + thanksToAdd;
  // final totalUpdated = total + totalToAdd;

  await docRefUser.update({
    'intelligence': intelligenceUpdated,
    'care': careUpdated,
    'power': powerUpdated,
    'skill': skillUpdated,
    'patience': patienceUpdated,
  });

  await docRefTask.delete();
}

Future<void> deleteTask(docId) async {
  // ユーザー情報取得
  await FirebaseFirestore.instance.collection('todoList').doc(docId).delete();
}
