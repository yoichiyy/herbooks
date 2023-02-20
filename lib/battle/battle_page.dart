import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/home_page.dart';
import 'package:counter/task_list/task_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '戦闘画面',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //
      home: ChangeNotifierProvider<TaskModel>(
        create: (_) => TaskModel()
          ..getTodoListRealtime()
          ..getUserGraph(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('戦闘'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pushReplacement<MaterialPageRoute, MyHomePage>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Consumer<TaskModel>(
              builder: (context, model, child) {
                final todoList = model.todoListFromModel;

                return model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              lineHeight: 20.0,
                              percent: model.paThanks / 100,
                              center: Text(
                                "Pa:${model.paThanks.toString()}",
                                style: const TextStyle(fontSize: 12.0),
                              ),
                              leading: const Icon(Icons.rowing_outlined),
                              barRadius: const Radius.circular(16),
                              backgroundColor: Colors.grey,
                              progressColor: Colors.blue[200],
                            ),
                          ),
                          Text(
                              "知：${model.paIntelligence.toString()} 心：${model.paCare.toString()} 力：${model.paPower.toString()} 技：${model.paSkill.toString()} 忍：${model.paPatience.toString()}"),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 20.0,
                              leading: const Icon(Icons.pregnant_woman_rounded),
                              // trailing: const Text("右"),
                              percent: model.maThanks / 100,
                              center: Text(
                                "Ma:${model.maThanks.toString()}",
                              ),
                              barRadius: const Radius.circular(16),
                              progressColor: Colors.pink[100],
                            ),
                          ),
                          Text(
                              "知：${model.maIntelligence.toString()} 心：${model.maCare.toString()} 力：${model.maPower.toString()} 技：${model.maSkill.toString()} 忍：${model.maPatience.toString()}"),
                          Image.asset('images/character_cthulhu_shoggoth.png'),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: todoList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final todo = todoList[index];
                                return Dismissible(
                                  key: UniqueKey(),
                                  child: InkWell(
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
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 0.0, 0.0),
                                        child: Icon(Icons.tag_faces,
                                            color: Colors.white)),
                                  ),
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    color: const Color.fromRGBO(244, 67, 54, 1),
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 0.0, 20.0, 0.0),
                                      child: Icon(Icons.clear,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onDismissed: (direction) async {
                                    await updateAndRepeatTask(todo.id);
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
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
  final thanks = userInfo.data()!["thanks"] as int;
  // final total = userInfo.data()!["total"] as int;

  //PLUS用タスク情報取得
  final intelligenceToAdd = taskInfo.data()!["intelligence"] as int;
  final careToAdd = taskInfo.data()!["care"] as int;
  final powerToAdd = taskInfo.data()!["power"] as int;
  final skillToAdd = taskInfo.data()!["skill"] as int;
  final patienceToAdd = taskInfo.data()!["patience"] as int;
  final thanksToAdd = taskInfo.data()!["thanks"] as int;
  // final totalToAdd = userInfo.data()!["total"] as int;

  //PLUS処理＆UP
  final intelligenceUpdated = intelligence + intelligenceToAdd;
  final careUpdated = care + careToAdd;
  final powerUpdated = power + powerToAdd;
  final skillUpdated = skill + skillToAdd;
  final patienceUpdated = patience + patienceToAdd;
  final thanksUpdated = thanks + thanksToAdd;
  // final totalUpdated = total + totalToAdd;

  await docRefUser.update({
    'intelligence': intelligenceUpdated,
    'care': careUpdated,
    'power': powerUpdated,
    'skill': skillUpdated,
    'patience': patienceUpdated,
    'thanks': thanksUpdated,
    // 'total': totalUpdated,
  });
}
