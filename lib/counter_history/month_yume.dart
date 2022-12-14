import 'package:counter/counter_history/history_model_month.dart';
import 'package:counter/counter_history/history_page_haru.dart';
import 'package:counter/counter_history/history_page_yume.dart';
import 'package:counter/user_Edits.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyLogYume extends StatelessWidget {
  const MonthlyLogYume({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<MonthlyHistoryModel>(
        create: (_) => MonthlyHistoryModel()..fetchMonthlyHistory(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('履歴(月)'),
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 0),
          body: Consumer<MonthlyHistoryModel>(
            builder: (context, model, child) {
              final historyData = model.monthlyHistoryListYume;
              // final userData = model.userList;

              return ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final monthToDisplay = historyData[index].monthId;
                  return Card(
                    child: ListTile(
                      leading: Text(historyData[index].monthString),
                      title: Text("${historyData[index].count.toString()}冊"),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistoryPageYume(monthToDisplay),
                          ),
                        );
                        // model.fetchMonthlyHistory();
                      },
                    ),
                  );
                },
              );
            },
          ),
          // ここから
          floatingActionButton: FloatingActionButton(
            heroTag: "hero3",
            child: const Icon(Icons.person_add_alt),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UsersEdits()));
            },
          ),
          // ここまで
        ),
      ),
    );
  }
}
