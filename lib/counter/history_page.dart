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
                  return Card(
                    child: ListTile(
                      leading: Text(historyData[index].dateString),
                      title: Text("${historyData[index].count.toString()}冊"),
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
  History(DocumentSnapshot doc) {
    count = doc['count'];
    date = doc['date'];
    dateString = doc['date_string'];
  }
  int? count;
  String date = "";
  String dateString = "";
}
