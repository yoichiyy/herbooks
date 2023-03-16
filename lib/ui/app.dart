// import 'package:counter/counter/home_page.dart';
import 'package:counter/counter/num_count.dart';
import 'package:counter/counter_history/history_model.dart';
import 'package:counter/counter_history/history_model_month.dart';
import 'package:counter/task_list/task_model.dart';
import 'package:counter/ui/pageview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user/signin.dart';

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskModel>(
          create: (_) => TaskModel()..getTodoListRealtime(),
          // ..getUserGraph(),
        ),
        // ChangeNotifierProvider<EditTaskModel>(create: (_) => EditTaskModel()),
        ChangeNotifierProvider<NumCountModel>(create: (_) => NumCountModel()),
        ChangeNotifierProvider<HistoryModel>(create: (_) => HistoryModel()),
        ChangeNotifierProvider<MonthlyHistoryModel>(
            create: (_) => MonthlyHistoryModel()),
        // ChangeNotifierProvider<TaskMonsterModel>(
        //     create: (_) => TaskMonsterModel()),
      ],
      child: MaterialApp(
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
      ),
    );
  } //まてりある
}
