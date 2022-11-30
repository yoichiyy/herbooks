import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UtilMovePage {
  void normalPush(BuildContext context, var page) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void pushAndRemove(BuildContext context, var page) {
    Navigator.pushAndRemoveUntil(context,
        new MaterialPageRoute(builder: (context) => page), (_) => false);
  }
}
