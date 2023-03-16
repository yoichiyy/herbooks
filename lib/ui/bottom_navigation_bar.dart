import 'package:counter/counter/home_page.dart';
import 'package:counter/kakei_history/all_history.dart';
import 'package:counter/task_list/task_monster.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[400],
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed, //4つ以上なら、サイズが大きすぎるので。横幅収まるように調整する。

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.cruelty_free),
          label: "TODO",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.android),
          label: "履歴",
        ),

        // BottomNavigationBarItem(
        //   icon: Icon(Icons.cruelty_free),
        //   label: "Task",
        // ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (context) => const TaskMonster()));
        }

        if (index == 1) {
          Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        }

        if (index == 2) {
          Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (context) => const AllHistory()));
        }
      },
    );
  }
}
