import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    child: const Text("履歴：スプレッドシート"),
                    onPressed: () => _openUrl(),
                  )
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

void _openUrl() async {
  final url = Uri.parse(
      'https://docs.google.com/spreadsheets/d/1fMdeCbePbmxmJ_3rjz69g-ng1dOaoyuR9zZl6KugPy8/edit#gid=1174254070&range=A1');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'このURLにはアクセスできません';
  }
}
