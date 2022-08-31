import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
                      leading: Text(historyData[index].date),
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
        await FirebaseFirestore.instance.collection('historyCounter').get();
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
  }
  int? count;
  String date = "";
}




// class HistoryPage extends StatelessWidget {
//   const HistoryPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("履歴"),
//         automaticallyImplyLeading: false,
//       ),
//       bottomNavigationBar: BottomBar(currentIndex: 2),
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [
//               Colors.blue.shade100.withOpacity(0.2),
//               Colors.red.shade500.withOpacity(0.2)
//             ])),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [




//           ],
//         ),
//       ),
//     );
//   }
// }

// class ListTileText extends StatelessWidget {
//   final String title;
//   final String text;
//   const ListTileText({required this.title, required this.text, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         style: DefaultTextStyle.of(context).style,
//         children: [
//           TextSpan(
//               text: "$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
//           TextSpan(text: text),
//         ],
//       ),
//     );
//   }
// }
