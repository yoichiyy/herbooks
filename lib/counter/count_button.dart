// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:counter/counter/count_model.dart';
// import 'package:flutter/material.dart';
// import '../utils/date_time.dart';

// //関数として切り出している。setStateは、そもそも相容れない。
// //返り値のかた。widget。

// //クラスとして切り出すことはできる！ →　基本的にはこっちが良い。パフォーマンスが良い場合も多い。

//                          Widget countButton(){
//   final dailyCount =
//       "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
//   final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
//   final totalCount = "total";
//                            return FloatingActionButton(
//                             onPressed: () async {
//                               //全カウント登録
//                               FirebaseFirestore.instance
//                                   .collection('totalCount')
//                                   .doc(totalCount)
//                                   .get()
//                                   .then(
//                                     //ここから
//                                     (docSnapshot) => {
//                                       if (docSnapshot.exists)
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('totalCount')
//                                               .doc(totalCount)
//                                               .update({
//                                             "count": FieldValue.increment(1)
//                                           })
//                                         }
//                                       else
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('totalCount')
//                                               .doc(totalCount)
//                                               .set(
//                                             {
//                                               "count": 1,
//                                             },
//                                           ),
//                                         },
//                                     },
//                                   ); //then

//                               //月単位のカウンター登録
//                               FirebaseFirestore.instance
//                                   .collection('monthlyCount')
//                                   .doc(monthlyCount)
//                                   .get()
//                                   .then(
//                                     //ここから
//                                     (docSnapshot) => {
//                                       if (docSnapshot.exists)
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('monthlyCount')
//                                               .doc(monthlyCount)
//                                               .update({
//                                             "count": FieldValue.increment(1)
//                                           })
//                                         }
//                                       else
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('monthlyCount')
//                                               .doc(monthlyCount)
//                                               .set(
//                                             {
//                                               "date": monthlyCount,
//                                               //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                                               //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                                               "count": 1,
//                                             },
//                                           ),
//                                         },
//                                     },
//                                   ); //then

//                               //日単位のカウンター登録
//                               FirebaseFirestore.instance
//                                   .collection('dailyCount')
//                                   .doc(dailyCount)
//                                   .get()
//                                   .then(
//                                     //ここから
//                                     (docSnapshot) => {
//                                       if (docSnapshot.exists)
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('dailyCount')
//                                               .doc(dailyCount)
//                                               .update({
//                                             "count": FieldValue.increment(1)
//                                           })
//                                         }
//                                       else
//                                         {
//                                           FirebaseFirestore.instance
//                                               .collection('dailyCount')
//                                               .doc(dailyCount)
//                                               .set(
//                                             {
//                                               "date": dailyCount,
//                                               "date_string":
//                                                   "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
//                                               //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
//                                               //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
//                                               "count": 1,
//                                             },
//                                           ),
//                                         },
//                                     },
//                                   ); //then

//                               setState(() {
//                                 getCounterForDay(dailyCount);
//                                 getCounterForMonth(monthlyCount);
//                                 getCounterForAll();
//                               });
//                             },
//                             child: const Icon(Icons.add),
//                           ),
//                          }