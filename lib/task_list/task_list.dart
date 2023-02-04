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
                          key: ObjectKey(todoIndex
                              .id), //ValueKeyとの違いはまだよくわかっとらん。ObjectKeyの方がすごそう。並べ替えできそう。でも今は並べ替えなんてしてないので、なんでここで６１３がつかったのかは謎
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
                              //削除
                              updateTaskStatus(todoIndex);
                              //TODO:dismissed Dismissible widget is still part of the tree.
                              //Make sure to implement the onDismissed handler and to immediately remove the Dismissible widget from the application once that handler has fired.

                            } else if (direction ==
                                DismissDirection.endToStart) {
                              updateTaskStatus(todoIndex);
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

Future<void> updateTaskStatus(todoIndex) async {
  //ユーザー情報取得
  // final snapshot =
  //     await FirebaseFirestore.instance.collection('users').doc(todoIndex).get();
  // final userName = snapshot.data()!['name'];

  final taskToUpDate = await FirebaseFirestore.instance
      .collection('todoList')
      .doc(todoIndex.id)
      .get();

  //_TypeError (type 'Timestamp' is not a subtype of type 'DateTime') =>とりあえずVARにした。FINALでも怒られない。違いは？ぐぐれ。
  final dueDate = taskToUpDate.data()!["dueDate"];
  final dueDateUpdated = dueDate.add(const Duration(days: 1));
  //TODO:NoSuchMethodError (NoSuchMethodError: Class 'Timestamp' has no instance method 'add'.
  // Receiver: Instance of 'Timestamp'
  // Tried calling: add(Instance of 'Duration'))


  // TODO:日付を＋１するだけなのに、一度get()してから、下のようにUPdateするのは無駄がある？
  // 該当DOC名を指定して、直接UPDATEする方法はあるか？
  //TODO:日付を１プラスする方法。incrementは無理ですよね。一度、dueDateを取得するしかないか？


  //TODO:taskToUpDateとして一度取得したのに、もう一度、下のように取得するしかないのか？
  FirebaseFirestore.instance.collection('todoList').doc(todoIndex.id).update({
    "dueDate": dueDateUpdated,
  });
}

