import 'package:flutter/material.dart';
import 'package:counter/counter/home_page.dart';
import '../counter/history_page.dart';
import '../task_list/task_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: const <Widget>[
        Center(
          child: Text('First Page'),
        ),
        Center(
          child: Text('Second Page'),
        ),
        Center(
          child: Text('Third Page'),
        ),
      ],
    );
  }
}








//ここから下は、上のエラーが解決してから、織り交ぜて行く




// class PageView extends StatelessWidget {
//    PageView({Key? key}) : super(key: key);

//   var _pages = [
//     MyHomePage(),
//     HistoryPage(),
//     TaskListPage(),
//   ];




//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: PageView.builder(
//             itemBuilder: (context, index) {
//               return _pages[index];
//             },
//             itemCount: _pages.length,
//           ),
//         ),
//       ),
//     );
//   }
// }
