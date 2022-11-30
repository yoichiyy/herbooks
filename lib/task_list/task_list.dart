import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../edit_task/edit_task.dart';
import '../edit_task/task_edit_page.dart';
import 'task_model.dart';
import 'package:provider/provider.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';

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
        // create: (_) => TaskModel()..getTodoListRealtime(),
        //インスタンス化した後に、コレに対して、メソッドをコールする。
        create: (_) {
          final taskModel = TaskModel(); //インスタンス化して
          taskModel.getTodoListRealtime(); //したものを、メソッドよんで、
          return taskModel; //かえす。（createなので）
        },
        child: Scaffold(
          bottomNavigationBar: BottomBar(currentIndex: 0),
          appBar: AppBar(
            title: Text('やること'),
          ),
          body: Consumer<TaskModel>(
            builder: (context, model, child) {
              final todoList = model.todoListFromModel;

              return ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (BuildContext context, int index) {
                  final todoIndex = todoList[index];
                  return Dismissible(
                    key: ValueKey(todoIndex),
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
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(
                        () {
                          //removeAtと、Firebaseのdelete両方をやる必要あるのかな？後者だけで良い感じも。→試してみる。
                          todoList.removeAt(index);
                          FirebaseFirestore.instance
                              .collection('todoList')
                              .doc(todoIndex.id)
                              .delete(); //そもそもこれは、doc.idがないので、おそらく動かぬ。
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
          // ここから
          floatingActionButton: FloatingActionButton(
            heroTag: "hero2",
            child: const Icon(Icons.person_add_alt),
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
