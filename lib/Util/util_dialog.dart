import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilDialog {
  void okDialog(BuildContext context, String title, String content) {
    showDialog<CupertinoAlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
