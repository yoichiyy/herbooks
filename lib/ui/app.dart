import 'package:counter/counter/home_page.dart';
import 'package:flutter/material.dart';


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
