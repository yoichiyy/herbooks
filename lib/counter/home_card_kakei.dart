import 'package:counter/kakei_history/history_page_kakei.dart';
import 'package:flutter/material.dart';

class HomeCardWidgetKakei extends StatelessWidget {
  const HomeCardWidgetKakei(
      {Key? key, required this.color, required this.title, required this.child})
      : super(key: key);

  final Color color;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryPageKakei(),
                          ),
                        );
                      },
                      child: const Text("詳細"))
                ],
              ),
              Flexible(
                child: Center(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
