import 'package:counter/counter/home_page.dart';
import 'package:counter/kakei_history/all_history.dart';
import 'package:counter/task_list/task_monster.dart';
import 'package:flutter/material.dart';
import '../task_list/task_list.dart';

class PageViewClass extends StatelessWidget {
  const PageViewClass({super.key});

//変数であった。final。中身が変わる。 pagesというメソッドにした（getter)。「Javaゲッター　dartゲッター」
  List<Widget> get pages => [
        const TaskMonster(),
        const MyHomePage(),
        const AllHistory(),
      ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);

    return PageView(
      controller: controller,
      children: const <Widget>[
        Center(
          child: TaskMonster(),
        ),
        Center(
          child: MyHomePage(),
        ),
        Center(
          child: AllHistory(),
        ),
      ],
    );
  }
}
