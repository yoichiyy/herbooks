import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/home_page.dart';
import 'package:counter/kakei_history/all_history.dart';
import 'package:counter/task_list/task_monster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PageViewClass extends StatelessWidget {
  const PageViewClass({required Key key}) : super(key: key);

  List<Widget> get pages => [
        const TaskMonster(key: ValueKey('taskMonster')),
        const MyHomePage(key: ValueKey('myHomePage')),
        const AllHistory(key: ValueKey('allHistory')),
      ];

Future<bool> checkTodaysTask() async {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    // ユーザーがログインしていない場合は、falseを返す
    return false;
  }

  final querySnapshotTodaysTask = await FirebaseFirestore.instance
    .collection('todoList')
    .where('user', isEqualTo: user.uid)
    .where('dueDate', isGreaterThanOrEqualTo: startOfDay)
    .where('dueDate', isLessThan: endOfDay)
    .get();

  return querySnapshotTodaysTask.docs.isNotEmpty;
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkTodaysTask(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final int initialPage = snapshot.data == true ? 0 : 1;
          final PageController controller = PageController(initialPage: initialPage);

          return PageView(
            controller: controller,
            children: const <Widget>[
              Center(
                child: TaskMonster(key: ValueKey('taskMonster')),
              ),
              Center(
                child: MyHomePage(key: ValueKey('myHomePage')),
              ),
              Center(
                child: AllHistory(key: ValueKey('allHistory')),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
