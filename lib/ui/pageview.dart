import 'package:counter/counter/home_page.dart';
import 'package:counter/kakei_history/all_history.dart';
import 'package:flutter/material.dart';

import '../task_list/task_list.dart';

class PageViewClass extends StatelessWidget {
  const PageViewClass({super.key});

//変数であった。final。中身が変わる。 pagesというメソッドにした（getter)。「Javaゲッター　dartゲッター」
  List<Widget> get pages => [
         TaskListPage(),
        const MyHomePage(),
        const AllHistory(),
      ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 1);

    return PageView(
      controller: controller,
      children:  <Widget>[
        Center(
          child: TaskListPage(),
        ),
        const Center(
          child: MyHomePage(),
        ),
        const Center(
          child: AllHistory(),
        ),
      ],
    );
  }
}
