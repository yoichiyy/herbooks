import 'package:counter/edit_history/edit_history.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<HistoryModel>(
        create: (_) => HistoryModel()..fetchHistory(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('履歴'),
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 2),
          body: Consumer<HistoryModel>(
            builder: (context, model, child) {
              final historyData = model.historyList;
              return ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final historyIndex = historyData[index];
                  return Card(
                    child: ListTile(
                      leading: Text(historyData[index].dateString),
                      title: Text("${historyData[index].count.toString()}冊"),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHistoryPage(historyIndex),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class HistoryModel extends ChangeNotifier {
  List<History> historyList = [];

  Future<void> fetchHistory() async {
    final docs =
        await FirebaseFirestore.instance.collection('dailyCount').get();
    final readingHistory = docs.docs.map((doc) => History(doc)).toList();
    readingHistory.sort((a, b) => b.date.compareTo(a.date));
    historyList = readingHistory;
    notifyListeners();
  }
}

class History {
  String id = "";
  int count = 0;
  String date = "";
  String dateString = "";

  // コンストラクタ = クラスのインスタンスを作成するメソッド
  // Hisotry(this.count, this.anotherParam);　位置引数。(positional)
  // History({required this.count, required this.anotherParam});//名前付き引数 named argument

  History(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    count = documentSnapshot['count'];
    date = documentSnapshot['date'];
    dateString = documentSnapshot['date_string'];
    id = documentSnapshot.id;
  }

  // History(DocumentSnapshot doc) {
  //   count = doc['count'];
  //   date = doc['date'];
  //   dateString = doc['date_string'];
  //   id = doc.id;
  // }
}
