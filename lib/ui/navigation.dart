import 'package:counter/counter/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> navigateToHistory(BuildContext context) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const HistoryPage(),
    ),
  );
}
