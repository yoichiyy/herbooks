// import 'package:counter/counter/home_page.dart';
import 'package:counter/login.dart';
import 'package:counter/ui/pageview.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'HaruEhonApp',
      // theme: ThemeData(
      //   primarySwatch: Colors.amber,
      // ),
      home: Scaffold(
        // appBar: AppBar(title: const Text("HaruEhonApp")),
        body: LoginPage(),
        // home: PageView(),
      ),
    );
  }
}
