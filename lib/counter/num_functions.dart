import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/Util/date_time.dart';

// 月の冊数カウント
Future<int> getCounterForMonth(String monthlyCount, String musume) async {
  final _store = FirebaseFirestore.instance;
  final monthData = await _store
      .collection('newCount')
      .where('musume', isEqualTo: musume)
      .where('month', isEqualTo: monthlyCount)
      .get();

  List data = monthData.docs;
  int sumMonth = 0;

  //複数のDOCをここから合計する
  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['count']) as int;
    // print(count.toString());
    // print(count.runtimeType);
    sumMonth += count;
  }
  return sumMonth;
}

// final data2 = monthData.docs[0].data();
// final countMonth = data2['count'];
// return countMonth;
//Kboyさんとのセッション。stampをStringとして表示させること＋QUERYの書き方
//https://stackoverflow.com/questions/54014679/return-type-of-timestamp-from-firestore-and-comparing-to-datetime-now-in-flutt
//firebase firestore timestamp greater than flutter
//https://flutter.ctrnost.com/basic/interactive/form/datapicker/
//1.端末に保存.１回は取得する必要はある。日付KEY→valueローカルストレージ。もしも見つからなければデータ取りに行くというコード。
//2.firesotore→cloudfunctionで集計できる。書き込んだタイミング→→全日付データのdoc KEY日付　VALUE冊数。新しいコレクション
//oncleate　トリガー。来たら、それが作られるようなのつくる。「valueを１増やして」・・・functionを一つかまさないと成らぬ。難易度高い。

// 日の冊数カウント
Future<int> getCounterForDay(String dailyCount, String musume) async {
//newCountにdoc検索を変えたバージョン
  final _store = FirebaseFirestore.instance;
  var dayData = await _store
      .collection('newCount')
      .where('musume', isEqualTo: musume)
      .where('date', isEqualTo: dailyCount)
      .get();

  List data = dayData.docs;
  int sumDay = 0;

  //複数のDOCをここから合計する
  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['count']) as int;
    // print(count.toString());
    // print(count.runtimeType);
    sumDay += count;
  }
  return sumDay;
}

//　全冊数のカウント
Future<int> fetchReadCountAll(String musume) async {
  final _store = FirebaseFirestore.instance;
  final allData = await _store
      .collection('newCount')
      .where('musume', isEqualTo: musume)
      .get();

  List data = allData.docs;
  int sumAll = 0;

  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['count']) as int;
    sumAll += count;
  }
  return sumAll;
}

DateTime getDateFromId(String id) {
  final getListOfNumbers = id.split("-").reversed.toList();
  return DateTime(int.parse(getListOfNumbers[0]),
      int.parse(getListOfNumbers[1]), int.parse(getListOfNumbers[2]));
}

// 家計の方

Future<int> getKakeiForDay(String dailyCount, String musume) async {
  final _store = FirebaseFirestore.instance;
  var dayData = await _store
      .collection('kakei')
      .where('date', isEqualTo: dailyCount)
      .get();

  List data = dayData.docs;
  int sumDay = 0;

  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['amount']) as int;
    sumDay += count;
  }
  return sumDay;
}

// 家計の方
Future<int> getKakeiForMonth(String monthlyCount, String musume) async {
  final _store = FirebaseFirestore.instance;
  final monthData = await _store
      .collection('kakei')
      .where('month', isEqualTo: monthlyCount)
      .get();

  List data = monthData.docs;
  int sumMonth = 0;

  //複数のDOCをここから合計する
  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['amount']) as int;
    sumMonth += count;
  }
  return sumMonth;
}

// 家計の方
Future<int> getKakeiForAll(String oya) async {
//新しい、newCountのコード
//上のdailyのカウント取得との違いは、「最初にnewCountのすべて」を取得している。
  final _store = FirebaseFirestore.instance;
  final allData = await _store.collection('kakei').get();

  List data = allData.docs;
  int sumAll = 0;

  for (int i = 0; i < data.length; i++) {
    final count = (data[i].data()['amount']) as int;
    sumAll += count;
  }
  return sumAll;
}


