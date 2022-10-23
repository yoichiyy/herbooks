// import 'package:counter/counter/home_page.dart';
import 'package:counter/ui/pageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../signin.dart';

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  //こうすけさんコード
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter app',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // 1.User が null でなないこと確認 →ホームへ
              return const PageViewClass();
            }
            //widget→変わらないものとして定義したいところ＝const

            // User が null である、つまり未サインインのサインイン画面へ
            return const SigninPage();
          },
        ),
      );
}

    //元のコード
//     Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'HaruEhonApp',
//       // theme: ThemeData(
//       //   primarySwatch: Colors.amber,
//       // ),
//       home: Scaffold(
//         // appBar: AppBar(title: const Text("HaruEhonApp")),
//         body: LoginPage(),
//         // home: PageView(),
//       ),
//     );
//   }
// }
