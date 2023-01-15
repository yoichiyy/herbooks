// import 'package:counter/kakei_history/history_model_month_kakei.dart';
// import 'package:counter/kakei_history/history_page_kakei.dart';
// import 'package:counter/user_Edits.dart';
// import 'package:counter/ui/bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MonthlyLogKakei extends StatelessWidget {
//   const MonthlyLogKakei({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider<MonthlyKakeiHistoryModel>(
//         create: (_) => MonthlyKakeiHistoryModel()..fetchMonthlyHistory(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('履歴(月)'),
//           ),
//           bottomNavigationBar: const BottomBar(currentIndex: 3),
//           body: Consumer<MonthlyKakeiHistoryModel>(
//             builder: (context, model, child) {
//               final historyData = model.monthlyHistoryListKakei;
//               // final userData = model.userList;

//               return ListView.builder(
//                 itemCount: historyData.length,
//                 itemBuilder: (context, index) {
//                   final monthToDisplay = historyData[index].month;
//                   return Card(
//                     child: ListTile(
//                       leading: Text(historyData[index].date),
//                       title: Text("${historyData[index].amount.toString()}円"),
//                       trailing: const Icon(Icons.more_vert),
//                       onTap: () async {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 HistoryPageKakei(monthToDisplay),
//                           ),
//                         );
//                         // model.fetchMonthlyHistory();
//                       },
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
