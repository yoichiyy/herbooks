import 'package:counter/counter/history_page_haru.dart';
import 'package:counter/counter/home_page.dart';
import 'package:flutter/material.dart';
import '../counter/history_page_yume.dart';
import '../task_list/task_list.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key, required this.currentIndex}) : super(key: key);

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.baby_changing_station_rounded),
          label: "夢",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.android),
          label: "晴",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cruelty_free),
          label: "Task",
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryPageYume()));
        }

        if (index == 1) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        }

        if (index == 2) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryPage()));
        }
        if (index == 3) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TaskListPage()));
        }
      },
    );
  }
}
