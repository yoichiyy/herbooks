// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:counter/ui/app.dart';

// class LoginPageBeforeNav extends StatelessWidget {
//   const LoginPageBeforeNav({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Welcome to Flutter',
//         home: LoginPage() //画面遷移をする部分を下のように別のクラスで定義し、それを読み込む
//         );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // メッセージ表示用
//   String infoText = '';
//   // 入力したメールアドレス・パスワード
//   String email = '';
//   String password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // メールアドレス入力
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'メールアドレス'),
//                 onChanged: (String value) {
//                   setState(() {
//                     email = value;
//                   });
//                 },
//               ),
//               // パスワード入力
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'パスワード'),
//                 obscureText: true,
//                 onChanged: (String value) {
//                   setState(() {
//                     password = value;
//                   });
//                 },
//               ),
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 // メッセージ表示
//                 child: Text(infoText),
//               ),
//               Container(
//                 width: double.infinity,
//                 // ユーザー登録ボタン
//                 child: ElevatedButton(
//                   child: const Text('ユーザー登録'),
//                   onPressed: () async {
//                     try {
//                       // メール/パスワードでユーザー登録
//                       final FirebaseAuth auth = FirebaseAuth.instance;
//                       await auth.createUserWithEmailAndPassword(
//                         email: email,
//                         password: password,
//                       );

//                       // ユーザー登録に成功した場合
//                       // チャット画面に遷移＋ログイン画面を破棄
//                       await Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) {
//                           return const MyApp();
//                         }),
//                       );
//                     } catch (e) {
//                       // ユーザー登録に失敗した場合
//                       setState(() {
//                         infoText = "登録に失敗しました：${e.toString()}";
//                       });
//                     }
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
