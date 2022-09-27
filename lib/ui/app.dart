import 'package:counter/counter/home_page.dart';
import 'package:flutter/material.dart';

import '../counter/history_page.dart';
import '../task_list/task_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HaruEhonApp',
      // theme: ThemeData(
      //   primarySwatch: Colors.amber,
      // ),
      home: MyHomePage(),
    );
  }
}

 var _pages = [
    MyHomePage(
    ),
    HistoryPage(
    ),
    TaskListPage(
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageView.builder(
            itemBuilder: (context, index) {
              return _pages[index];
            },
            itemCount: _pages.length,
          ),
        ),
      ),
    );
  }