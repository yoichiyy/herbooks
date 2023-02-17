import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_model.dart';

class ThankList extends StatelessWidget {
  const ThankList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //
      home: ChangeNotifierProvider<TaskModel>(
        create: (_) => TaskModel()..getThankList(),
        child: Scaffold(
          bottomNavigationBar: const BottomBar(currentIndex: 0),
          appBar: AppBar(
            title: const Text('THANKS'),
          ),
          body: Consumer<TaskModel>(
            builder: (context, model, child) {
              final thankList = model.thankListFromModel;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: thankList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final thanks = thankList[index];
                        return InkWell(
                          child: Card(
                            child: ListTile(
                              title: Text(thanks.note),
                              subtitle: Text('to:${thanks.to}'),
                              trailing: Text(
                                  '${thanks.time?.month}/${thanks.time?.day}'),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
