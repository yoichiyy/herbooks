// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../utils/date_time.dart';

// class CountButton extends ChangeNotifier {
//   final int booknum = 0;
//   final dailyCount =
//       "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
//   final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
//   final totalCount = "total";


//   Future<void> CountButtonFunction(booknum) async {
//         //全カウント登録
//         await FirebaseFirestore.instance
//             .collection('totalCount')
//             .doc(totalCount)
//             .get()
//             .then(
//               //ここから
//               (docSnapshot) => {
//                 if (docSnapshot.exists)
//                   {
//                     FirebaseFirestore.instance
//                         .collection('totalCount')
//                         .doc(totalCount)
//                         .update({"count": FieldValue.increment(booknum)})
//                   }
//                 else
//                   {
//                     FirebaseFirestore.instance
//                         .collection('totalCount')
//                         .doc(totalCount)
//                         .set(
//                       {
//                         "count": 1,
//                       },
//                     ),
//                   },
//               },
//             ); //then

//         //月単位のカウンター登録
//         await FirebaseFirestore.instance
//             .collection('monthlyCount')
//             .doc(monthlyCount)
//             .get()
//             .then(
//               //ここから
//               (docSnapshot) => {
//                 if (docSnapshot.exists)
//                   {
//                     FirebaseFirestore.instance
//                         .collection('monthlyCount')
//                         .doc(monthlyCount)
//                         .update({"count": FieldValue.increment(booknum)})
//                   }
//                 else
//                   {
//                     FirebaseFirestore.instance
//                         .collection('monthlyCount')
//                         .doc(monthlyCount)
//                         .set(
//                       {
//                         "date": monthlyCount,
//                         //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                         //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                         "count": 1,
//                       },
//                     ),
//                   },
//               },
//             ); //then

//         //日単位のカウンター登録
//         await FirebaseFirestore.instance
//             .collection('dailyCount')
//             .doc(dailyCount)
//             .get() //処理の順番を管理しにくくなってる
//             //一度、取得して、その値を別の所で使ったほうがよさそう。
//             .then(
//               //ここから
//               (docSnapshot) => {
//                 if (docSnapshot.exists)
//                   {
//                     FirebaseFirestore.instance
//                         .collection('dailyCount')
//                         .doc(dailyCount)
//                         .update({"count": FieldValue.increment(booknum)})
//                   }
//                 else
//                   {
//                     FirebaseFirestore.instance
//                         .collection('dailyCount')
//                         .doc(dailyCount)
//                         .set(
//                       {
//                         "date": dailyCount,
//                         "date_string":
//                             "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
//                         //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                         //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                         "count": 1,
//                       },
//                     ),
//                   },
//               },
//             ); //then
//         //順番関係ないけど、終わってから次に行きたいとき。並行処理できない。効率悪い。
//         // await Future.delayed(Duration(seconds: 3));

//         // await Future.wait<void>([
//         //   getCounterForDay(dailyCount),
//         //   getCounterForMonth(monthlyCount),
//         //   getCounterForAll(),
//         // ]);
//         notifyListeners();
//       } //fabButtonFunction
//   }






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../utils/date_time.dart';

// class CountButton extends StatefulWidget {
//   final int booknum;

//   //コンストラクタ　カウントボタンを使うときに、こういう引数を使えと、定義。
//   //
//   const CountButton({Key? key, required this.booknum}) : super(key: key);
//   @override
//   State<CountButton> createState() => _CountButtonState();
// }

// class _CountButtonState extends State<CountButton> {
//   final dailyCount =
//       "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
//   final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
//   final totalCount = "total";

//   @override

//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 60,
//       height: 60,
//       child: ElevatedButton(
//         //ステートフルで、受け取った引数の使い方。さっきの記事にあった。
//         child: Text(widget.booknum.toString()),
//         style: ElevatedButton.styleFrom(
//           primary: Colors.grey[300],
//           onPrimary: Colors.purple,
//           textStyle: const TextStyle(
//             fontSize: 20,
//           ),
//         ),
//         onPressed: () async {
//           //全カウント登録
//           FirebaseFirestore.instance
//               .collection('totalCount')
//               .doc(totalCount)
//               .get()
//               .then(
//                 //ここから
//                 (docSnapshot) => {
//                   if (docSnapshot.exists)
//                     {
//                       FirebaseFirestore.instance
//                           .collection('totalCount')
//                           .doc(totalCount)
//                           .update(
//                               {"count": FieldValue.increment(widget.booknum)})
//                     }
//                   else
//                     {
//                       FirebaseFirestore.instance
//                           .collection('totalCount')
//                           .doc(totalCount)
//                           .set(
//                         {
//                           "count": 1,
//                         },
//                       ),
//                     },
//                 },
//               ); //then

//           //月単位のカウンター登録
//           FirebaseFirestore.instance
//               .collection('monthlyCount')
//               .doc(monthlyCount)
//               .get()
//               .then(
//                 //ここから
//                 (docSnapshot) => {
//                   if (docSnapshot.exists)
//                     {
//                       FirebaseFirestore.instance
//                           .collection('monthlyCount')
//                           .doc(monthlyCount)
//                           .update(
//                               {"count": FieldValue.increment(widget.booknum)})
//                     }
//                   else
//                     {
//                       FirebaseFirestore.instance
//                           .collection('monthlyCount')
//                           .doc(monthlyCount)
//                           .set(
//                         {
//                           "date": monthlyCount,
//                           //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                           //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                           "count": 1,
//                         },
//                       ),
//                     },
//                 },
//               ); //then

//           //日単位のカウンター登録
//           FirebaseFirestore.instance
//               .collection('dailyCount')
//               .doc(dailyCount)
//               .get()
//               .then(
//                 //ここから
//                 (docSnapshot) => {
//                   if (docSnapshot.exists)
//                     {
//                       FirebaseFirestore.instance
//                           .collection('dailyCount')
//                           .doc(dailyCount)
//                           .update(
//                               {"count": FieldValue.increment(widget.booknum)})
//                     }
//                   else
//                     {
//                       FirebaseFirestore.instance
//                           .collection('dailyCount')
//                           .doc(dailyCount)
//                           .set(
//                         {
//                           "date": dailyCount,
//                           "date_string":
//                               "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
//                           //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                           //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                           "count": 1,
//                         },
//                       ),
//                     },
//                 },
//               ); //then

//         notifyListeners();
//         },
//       ),
//     );
//   }
// }
