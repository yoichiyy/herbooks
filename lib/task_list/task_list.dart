import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/task_edit/edit_task.dart';
import 'package:counter/task_list/thank_list.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../task_edit/create_task.dart';
import 'task_model.dart';

class TaskListPage extends StatelessWidget {
  TaskListPage({super.key});
  final player = AudioPlayer();

  //こんぶんさんADVICEそっくりやろうとしたが、どうやら話が違うようだ。
  // final Todo todo;
  // const TaskListPage(this.todo, {Key? key}) : super(key: key);
//   const TaskListPage({Key? key}) : super(key: key);
//   @override
//   State<TaskListPage> createState() => _TaskListPageState();
// }
// class _TaskListPageState extends State<TaskListPage> {
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
    return ChangeNotifierProvider<TaskModel>(
      // create: (_) {
      //   final taskModel = TaskModel(); //インスタンス化して
      //   taskModel.getTodoListRealtime(); //したものを、メソッドよんで、
      //   return taskModel; //かえす。（createなので）
      // },
      create: (_) => TaskModel()
        ..getTodoListRealtime()
        ..getUserGraph(),
      child: Scaffold(
        bottomNavigationBar: const BottomBar(currentIndex: 0),
        appBar: AppBar(
          title: const Text('やること'),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: OutlinedButton(
                child:
                    const Text('THANKS', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThankList(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: Consumer<TaskModel>(
          builder: (context, model, child) {
            final todoListOverDue = model.todoListFromModelOverDue;
            final todoListToday = model.todoListFromModelToday;
            final todoListAfterToday = model.todoListFromModelAfterToday;
            // final list1 = ["1", "2", "3"];
            // final list1 = model.todoListFromModelOverDue;
            // final list2 = ["あ", "い", "う", "え"];
            // final list3 = ["a", "b", "c", "d", "e"];

            return model.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        //monster Graph
                        padding: const EdgeInsets.all(15.0),
                        child: StreamBuilder<Object>(
                            //TODO:ここ、次のTODOどうにかしないと。
                            //ここモンスタークラスにする
                            stream: null,
                            //repositoryパターン。外部のデータにアクセスするとき。firestoreとか。レポジトリ層
                            builder: (context, snapshot) {
                              return LinearPercentIndicator(
                                width: MediaQuery.of(context).size.width - 100,
                                lineHeight: 20.0,
                                percent: model.monsterHp / model.monsterHpMax,
                                center: Text(
                                  "HP:${model.monsterHp.toString()}",
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                animation: true,
                                animationDuration: 1000,
                                leading: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset('images/shoggoth.png'),
                                ),
                                barRadius: const Radius.circular(16),
                                backgroundColor: Colors.grey,
                                progressColor: Colors.blue[200],
                              );
                            }),
                      ),
                      GestureDetector(
                        //monsterのステートフルを作る。
                        onTap: () async {
                          await player.setSource(AssetSource('sword.mp3'));
                          debugPrint("なってるはず");
                        },
                        child: SizedBox(
                          //Monster Pic
                          height: 150,
                          width: 150,
                          child: Image.asset('images/shoggoth.png'),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(15.0),
                      //   child: LinearPercentIndicator(
                      //     width: MediaQuery.of(context).size.width - 100,
                      //     lineHeight: 20.0,
                      //     percent: model.paHp / model.paHpMax,
                      //     center: Text(
                      //       "Pa:${model.paHp.toString()}",
                      //       style: const TextStyle(fontSize: 12.0),
                      //     ),
                      //     animation: true,
                      //     animationDuration: 1000,
                      //     leading: const Icon(Icons.rowing_outlined),
                      //     barRadius: const Radius.circular(16),
                      //     backgroundColor: Colors.grey,
                      //     progressColor: Colors.blue[200],
                      //   ),
                      // ),
                      // Text(
                      //     "知${model.paIntelligence.toString()}  心${model.paCare.toString()}  力${model.paPower.toString()}  技${model.paSkill.toString()}  忍${model.paPatience.toString()}  ♡${model.paThanks.toString()}"),
                      // Padding(
                      //   padding: const EdgeInsets.all(15.0),
                      //   child: LinearPercentIndicator(
                      //     width: MediaQuery.of(context).size.width - 100,
                      //     lineHeight: 20.0,
                      //     leading: const Icon(Icons.pregnant_woman_rounded),
                      //     // trailing: const Text("右"),
                      //     percent: model.maHp / model.maHpMax,
                      //     center: Text(
                      //       "Ma:${model.maHp.toString()}",
                      //     ),
                      //     animation: true,
                      //     animationDuration: 1000,
                      //     barRadius: const Radius.circular(16),
                      //     progressColor: Colors.pink[100],
                      //   ),
                      // ),
                      // Text(
                      //     "知${model.maIntelligence.toString()}  心${model.maCare.toString()}  力${model.maPower.toString()}  技${model.maSkill.toString()}  忍${model.maPatience.toString()}  ♡${model.maThanks.toString()}"),
                      //テスト中ListView.builder
                      Flexible(
                        child: CustomScrollView(slivers: [
                          SliverToBoxAdapter(child: bar("期限切れ")),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: todoListOverDue.length,
                              (context, index) {
                                return TaskChan(todoListOverDue);
                              },
                            ),
                          ),
                          // SliverToBoxAdapter(child: bar("今日")),
                          // SliverList(
                          //   delegate: SliverChildBuilderDelegate(
                          //     childCount: todoListToday.length,
                          //     (context, index) {
                          //       return TaskChan(todoListToday);
                          //     },
                          //   ),
                          // ),
                          // SliverToBoxAdapter(child: bar("明日以降")),
                          // SliverList(
                          //   delegate: SliverChildBuilderDelegate(
                          //     childCount: todoListAfterToday.length,
                          //     (context, index) {
                          //       return TaskChan(todoListAfterToday);
                          //     },
                          //   ),
                          // ),
                        ]),
                      ),
                    ],
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "hero2",
          child: const Icon(Icons.egg_alt),
          onPressed: () {
            Navigator.push<void>(context,
                MaterialPageRoute(builder: (context) => const TaskCard()));
          },
        ),
      ),
    );
  }
}

class TaskChan extends StatelessWidget {
  const TaskChan(this.listFromParent, {super.key});
  final List<Todo> listFromParent;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskModel>(
      create: (_) => TaskModel()..getTodoListRealtime(),
      child: Consumer<TaskModel>(
        builder: (context, model, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //ここのflexibleを外しても、何も変わらない。//TODO:
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listFromParent.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = listFromParent[index];
                  return Dismissible(
                    key: ValueKey(todo.id),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskPage(todo),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          tileColor: todo.user == "まま"
                              ? Colors.red[50]
                              : Colors.blue[50],
                          title: Text(
                              '${todo.taskNameOfTodoClass}　${todo.dueDate?.month}/${todo.dueDate?.day}  ${todo.dueDate?.hour}時'),
                        ),
                      ),
                    ),
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.green[200],
                      child: const Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Icon(Icons.tag_faces, color: Colors.white)),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      color: const Color.fromRGBO(244, 67, 54, 1),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                        child: Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                    onDismissed: (direction) async {
                      listFromParent.remove(todo);
                      if (direction == DismissDirection.startToEnd) {
                        if (todo.repeatOption) {
                          await model.updateAndRepeatTask(todo.id);
                        } else {
                          await model.updateAndDeleteTask(todo.id);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('モンスターに${todo.thanks}のダメージ！'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 2000),
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 2 -
                                    50),
                          ),
                        ); //messenger
                        //モンスターこうげき
                        await model.monsterAttack(todo.id);
                        //messenger
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${model.monsterOffense}のダメージを受けた！'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(milliseconds: 2000),
                            margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 2 -
                                    50),
                          ),
                        ); //snackbar
                        await model.getUserGraph();
                      } else if (direction == DismissDirection.endToStart) {
                        listFromParent.remove(todo);

                        // await deleteTask(todo.id);
                      } else {
                        debugPrint("Nothing");
                      }
                    },
                  ); //dismissible
                },
              ),
            ],
          );
        },
      ),
    ); //Consumer
  } //widget build
}

Future<void> deleteTask(String docId) async {
  // ユーザー情報取得
  await FirebaseFirestore.instance.collection('todoList').doc(docId).delete();
}

Widget bar(String title) {
  return Container(
    child: Center(
        child: Text(
      title, //共通化して、関数を利用した
      style: const TextStyle(color: Colors.white),
    )),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey,
    ),
    constraints: const BoxConstraints.expand(height: 30),
  );
}
