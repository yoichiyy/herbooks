import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/counter/count_model.dart';
import 'package:flutter/material.dart';
import '../utils/date_time.dart';

class CountButton extends StatefulWidget {
  const CountButton({Key? key}) : super(key: key);
  @override
  State<CountButton> createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  final totalCount = "total";

  @override
  //こういうことをやりたい。statefulWidgetの場合だから、引数を渡す方法が、この例とは違うんだろうと思うが・・・

  //class Instruction extends Column {
  // Instruction(
  //     BuildContext context, String title, String instruction)
  //     : super(
  //         children: [

  //https://zenn.dev/junki555/articles/4251f5a3846343#%E3%81%93%E3%81%86%E3%81%99%E3%82%8B

  Widget build(BuildContext context, int bookNum) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        child: Text(bookNum.toString()),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[300],
          onPrimary: Colors.purple,
          textStyle: const TextStyle(
            fontSize: 20,
          ),
        ),
        onPressed: () async {
          //全カウント登録
          FirebaseFirestore.instance
              .collection('totalCount')
              .doc(totalCount)
              .get()
              .then(
                //ここから
                (docSnapshot) => {
                  if (docSnapshot.exists)
                    {
                      FirebaseFirestore.instance
                          .collection('totalCount')
                          .doc(totalCount)
                          .update({"count": FieldValue.increment(bookNum)})
                    }
                  else
                    {
                      FirebaseFirestore.instance
                          .collection('totalCount')
                          .doc(totalCount)
                          .set(
                        {
                          "count": 1,
                        },
                      ),
                    },
                },
              ); //then

          //月単位のカウンター登録
          FirebaseFirestore.instance
              .collection('monthlyCount')
              .doc(monthlyCount)
              .get()
              .then(
                //ここから
                (docSnapshot) => {
                  if (docSnapshot.exists)
                    {
                      FirebaseFirestore.instance
                          .collection('monthlyCount')
                          .doc(monthlyCount)
                          .update({"count": FieldValue.increment(bookNum)})
                    }
                  else
                    {
                      FirebaseFirestore.instance
                          .collection('monthlyCount')
                          .doc(monthlyCount)
                          .set(
                        {
                          "date": monthlyCount,
                          //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                          //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                          "count": 1,
                        },
                      ),
                    },
                },
              ); //then

          //日単位のカウンター登録
          FirebaseFirestore.instance
              .collection('dailyCount')
              .doc(dailyCount)
              .get()
              .then(
                //ここから
                (docSnapshot) => {
                  if (docSnapshot.exists)
                    {
                      FirebaseFirestore.instance
                          .collection('dailyCount')
                          .doc(dailyCount)
                          .update({"count": FieldValue.increment(bookNum)})
                    }
                  else
                    {
                      FirebaseFirestore.instance
                          .collection('dailyCount')
                          .doc(dailyCount)
                          .set(
                        {
                          "date": dailyCount,
                          "date_string":
                              "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})",
                          //0-6の数字を返す。0=月... →リストを作れば良い。アプリ中でどこからでも使えるように。utils
                          //firebaseに、整数で入ってても、読み込むview側で、このjapaneseWeekday関数を使えば曜日表示可能。
                          "count": 1,
                        },
                      ),
                    },
                },
              ); //then
          //順番関係ないけど、終わってから次に行きたいとき。並行処理できない。効率悪い。
          await Future.wait<void>([
            getCounterForDay(dailyCount),
            getCounterForMonth(monthlyCount),
            getCounterForAll(),
          ]);

          setState(() {});
        },
      ),
    );
  }
}
