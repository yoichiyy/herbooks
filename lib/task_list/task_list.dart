import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../edit_task/create_task.dart';
import '../edit_task/edit_task.dart';
import 'task_model.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '絵本COUNTER_WEB版',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
                        final todoIndex = todoList[index];
                        return Dismissible(
                          // key: ObjectKey(todoIndex
                          //     .id),
                          key:
                              UniqueKey(), //ValueKeyとの違いはまだよくわかっとらん。ObjectKeyの方がすごそう。並べ替えできそう。でも今は並べ替えなんてしてないので、なんでここで６１３がつかったのかは謎
                          child: InkWell(
                            onTap: () async {
                              //ここでString title = ...とやっていることが理解できぬ。この
                              //title変数を、次のeditTaskページに渡しているようにも見えない。
                              // final String? title =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskPage(todoIndex),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    '${todoIndex.taskNameOfTodoClass}　${todoIndex.dueDate?.month}/${todoIndex.dueDate?.day}  ${todoIndex.dueDate?.hour}時'),
                              ),
                            ),
                          ),
                          background: Container(
                              color: const Color.fromRGBO(244, 67, 54, 1)),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.startToEnd) {
                              todoIndex.repeatOption
                                  ?
                                  //repeatならUPDATEして日付更新。
                                  //falseならPOINT付与だけして、タスク削除
                                  updateAndRepeatTask(todoIndex)
                                  : updateAndDeleteTask(todoIndex);
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              //逆方向スワイプで、付与せず削除
                              updateAndRepeatTask(todoIndex);
                            } else {
                              debugPrint("Nothing");
                            }
                            setState(
                              () {},
                            );
                            //TODO:dismissed Dismissible widget is still part of the tree.
                            //Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.
                            //99行目を変更して解決はしたのだが、仕組みを理解しておらぬ。ObjectKey, ValueKey。。。
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

Future<void> updateAndRepeatTask(todoIndex) async {
  //ユーザー情報取得
  // final snapshot =
  //     await FirebaseFirestore.instance.collection('users').doc(todoIndex).get();
  // final userName = snapshot.data()!['name'];
  final docRef =
      FirebaseFirestore.instance.collection('todoList').doc(todoIndex.id);
  final taskToUpDate = await docRef.get();

  //_TypeError (type 'Timestamp' is not a subtype of type 'DateTime') =>とりあえずVARにした。FINALでも怒られない。違いは？ぐぐれ。
  final dueDate = taskToUpDate.data()!["dueDate"] as Timestamp;
  final dueDateUpdated = dueDate.toDate().add(const Duration(days: 1));
  final dueDateAsTimeStamp = Timestamp.fromDate(dueDateUpdated);

  await docRef.update({
    "dueDate": dueDateAsTimeStamp,
    




  });
}

Future<void> updateAndDeleteTask(todoIndex) async {
  //ユーザー情報取得
  // final snapshot =
  //     await FirebaseFirestore.instance.collection('users').doc(todoIndex).get();
  // final userName = snapshot.data()!['name'];
  final docRef =
      FirebaseFirestore.instance.collection('todoList').doc(todoIndex.id);
  final taskToUpDate = await docRef.get();


  await docRef.update({
    "dueDate": ,
  });
}
