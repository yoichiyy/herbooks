import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HistorySumCard extends StatelessWidget {
  const HistorySumCard(
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
              Text(title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge),
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
  final url = Uri.parse('https://tinyurl.com/2d5c6cvc');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'このURLにはアクセスできません';
  }
}