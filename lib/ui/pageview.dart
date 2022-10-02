import 'package:flutter/material.dart';
import 'package:counter/counter/home_page.dart';
import '../counter/history_page.dart';
import '../task_list/task_list.dart';

class PageViewClass extends StatelessWidget {
  PageViewClass({super.key});

  final pages = [
    const TaskListPage(),
    const MyHomePage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);

    return PageView(
      controller: controller,
      children: const <Widget>[
        Center(
          child: TaskListPage(),
        ),
        Center(
          child: MyHomePage(),
        ),
        Center(
          child: HistoryPage(),
        ),
      ],
    );
  }
}
