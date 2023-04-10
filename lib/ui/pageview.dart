import 'package:counter/counter/home_page.dart';
import 'package:counter/kakei_history/all_history.dart';
import 'package:counter/task_list/task_monster.dart';
import 'package:flutter/material.dart';

class PageViewClass extends StatelessWidget {
  const PageViewClass({required Key key}) : super(key: key);

//変数であった。final。中身が変わる。 pagesというメソッドにした（getter)。「Javaゲッター　dartゲッター」
  List<Widget> get pages => [
        const TaskMonster(key: ValueKey('taskMonster')),
        const MyHomePage(key: ValueKey('myHomePage')),
        const AllHistory(key: ValueKey('allHistory')),
      ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: 0);
    //(initialPage: taskComplete ? 0:1);

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
  }
}
