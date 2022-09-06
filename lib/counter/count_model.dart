import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// 月の冊数カウント
Future<int> getCounterForMonth(String monthlyCount) async {
  final _store = FirebaseFirestore.instance;
  final monthData = await _store
      .collection('monthlyCount')
      .where('date', isEqualTo: monthlyCount)
      .get();

  final data = monthData.docs[0].data();
  //ぶんきをかく

  final countMonth = data['count'];
  return countMonth;

//Kboyさんとのセッション。stampをStringとして表示させること＋QUERYの書き方
  //https://stackoverflow.com/questions/54014679/return-type-of-timestamp-from-firestore-and-comparing-to-datetime-now-in-flutt
  //firebase firestore timestamp greater than flutter
  //https://flutter.ctrnost.com/basic/interactive/form/datapicker/
}

//1.端末に保存.１回は取得する必要はある。日付KEY→valueローカルストレージ。もしも見つからなければデータ取りに行くというコード。
//2.firesotore→cloudfunctionで集計できる。書き込んだタイミング→→全日付データのdoc KEY日付　VALUE冊数。新しいコレクション
//oncleate　トリガー。来たら、それが作られるようなのつくる。「valueを１増やして」・・・functionを一つかまさないと成らぬ。難易度高い。

// 日の冊数カウント
Future<int> getCounterForDay(String dailyCount) async {
  //細かく切って、一つ一つデータをとれているか確認すべし
  final _store = FirebaseFirestore.instance;
  var dayData = await _store
      .collection('dailyCount')
      .where('date', isEqualTo: dailyCount)
      .get();

  //querysnapshotから中のデータを取り出す。
  if (dayData.docs.isEmpty) {
    debugPrint("そういうものはありません。");
  } else {
    debugPrint("そういうものが、あります。");
  }
  final data = dayData.docs[0].data();
  final countDay = data['count'];
  return countDay;
}

//　全冊数のカウント
Future<int> getCounterForAll() async {
  final _store = FirebaseFirestore.instance;
  var allData = await _store.collection('totalCount').where("count").get();
  final data = allData.docs[0].data();
  final countAll = data['count'];
  return countAll;
}

String getIdFromDate(DateTime date) {
  return "${date.day}-${date.month}-${date.year}";
}

DateTime getDateFromId(String id) {
  final getListOfNumbers = id.split("-").reversed.toList();
  return DateTime(int.parse(getListOfNumbers[0]),
      int.parse(getListOfNumbers[1]), int.parse(getListOfNumbers[2]));
}

//作り直し。ifを外す
Future<void> addBook(DateTime dueDate, String taskName) async {
  if (taskName == "") {
    throw 'タイトルが入力されていません';
  }

  // firestoreに追加
  await FirebaseFirestore.instance.collection('books').add({
    'title': taskName,
    'author': dueDate,
  });
}
