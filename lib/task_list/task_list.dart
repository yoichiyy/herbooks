import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/task_list/todo_class.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../edit_task/create_task.dart';
import '../edit_task/edit_task.dart';
import 'task_model.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage(this.todo, {Key? key}) : super(key: key);
  final Todo todo;

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
                          key: ObjectKey(widget.todo.id),//ValueKeyとの違いはまだよくわかっとらん。ObjectKeyの方がすごそう。並べ替えできそう。でも今は並べ替えなんてしてないので、なんでここで６１３がつかったのかは謎
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
                                    '${todoIndex.taskNameOfTodoClass}　${todoIndex.createdAt?.month}/${todoIndex.createdAt?.day}  ${todoIndex.createdAt?.hour}時'),
                                // ${model.todo.createdAt?.month}/${model.todo.createdAt?.day}  ${model.todo.createdAt?.hour}時'),
                              ),
                            ),
                          ),
                          background: Container(
                              color: const Color.fromRGBO(244, 67, 54, 1)),
                          onDismissed: (direction) {

                            if (direction == DismissDirection.startToEnd) {
                              //削除
                              updateTaskStatus();
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              updateTaskStatus();
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

  Future<void> updateTaskStatus() async {

    await FirebaseFirestore.instance
        .collection("tasks")
        .doc()
        .update(
      {"task_status": ""},
    );


    // taskStatusUndoButton.value = this.taskID;

    // if (status == 1) {
    //   //1.関数は頭に必ずかたつけろ
    //   //2.if のかっこいい敵書き方は、推奨されぬ。リントをいれるならば。
    //   await updateUserPoints(this.taskPoints);
    // }

    // newTaskInserted.value = await this.makeRepeat();
    // if (this.specialNumber != "") {
    //   await APIS.addEntryInSheet(
    //     taskID: this.specialNumber,
    //     taskStatus: status,
    //     note: this.taskNote,
    //     points: this.taskPoints,
    //     taskName: this.taskName,
    //     due: this.taskDeadline.toDate(),
      // );
    }
  }
