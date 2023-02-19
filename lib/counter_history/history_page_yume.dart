import 'package:counter/user/user_Edits.dart';
import 'package:counter/edit_history/edit_history.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_model.dart';

class HistoryPageYume extends StatelessWidget {
  final String month;
  const HistoryPageYume(this.month, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<HistoryModel>(
        create: (_) => HistoryModel()..fetchHistory(month),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('履歴'),
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 2),
          body: Consumer<HistoryModel>(
            builder: (context, model, child) {
              final historyData = model.historyListYume;
              // final userData = model.userList;

              return ListView.builder(
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final historyIndex = historyData[index];
                  return Card(
                    child: ListTile(
                      leading: Text(historyData[index].dateString),
                      title: Text("${historyData[index].count.toString()}冊"),
                      subtitle: Text(historyData[index].user.toString()),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () async {
                        await Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHistoryPage(historyIndex),
                          ),
                        );
                        model.fetchHistory(month);
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
              Navigator.push<void>(context,
                  MaterialPageRoute(builder: (context) => const UsersEdits()));
            },
          ),
          // ここまで
        ),
      ),
    );
  }
}
