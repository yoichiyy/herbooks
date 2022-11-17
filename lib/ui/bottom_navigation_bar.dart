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
          icon: Icon(Icons.task),
          label: "Yume",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "Haru",
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
      },
    );
  }
}
