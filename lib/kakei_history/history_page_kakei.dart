// import 'package:counter/kakei_edit_history/edit_kakei_history.dart';
// import 'package:counter/kakei_history/history_model_kakei.dart';
// import 'package:counter/ui/bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class HistoryPageKakei extends StatelessWidget {
//   // final String month;
//   // const HistoryPageKakei(this.month, {Key? key}) : super(key: key);
//   const HistoryPageKakei({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChangeNotifierProvider<KakeiHistoryModel>(
//         create: (_) => KakeiHistoryModel()..fetchKakeiHistory(),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('履歴'),
//           ),
//           bottomNavigationBar: const BottomBar(currentIndex: 2),
//           body: Consumer<KakeiHistoryModel>(
//             builder: (context, model, child) {
//               final historyData = model.kakeiHistoryList;
//               // final userData = model.userList;

//               return ListView.builder(
//                 itemCount: historyData.length,
//                 itemBuilder: (context, index) {
//                   final historyIndex = historyData[index];
//                   return Card(
//                     child: ListTile(
//                       leading: Text(historyData[index].date),
//                       title: Text("${historyData[index].amount.toString()}円"),
//                       subtitle: Text(historyData[index].user.toString()),
//                       trailing: const Icon(Icons.more_vert),
//                       onTap: () async {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 EditKakeiHistoryPage(historyIndex),
//                           ),
//                         );
//                         model.fetchKakeiHistory(
//                             ); //別ページで編集してから戻ってきたときに、最新情報となる streamなどで読んでいれば、不要。
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
