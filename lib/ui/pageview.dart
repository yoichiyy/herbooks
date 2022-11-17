import 'package:flutter/material.dart';
import 'package:counter/counter/home_page.dart';
import '../counter/history_page_haru.dart';
import '../counter/history_page_yume.dart';

class PageViewClass extends StatelessWidget {
  const PageViewClass({super.key});

//変数であった。final。中身が変わる。 pagesというメソッドにした（getter)。「Javaゲッター　dartゲッター」
  List<Widget> get pages => [
        const HistoryPageYume(),
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
          child: HistoryPageYume(),
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
