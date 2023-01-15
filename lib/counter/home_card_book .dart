import 'package:flutter/material.dart';

class HomeCardWidgetBook extends StatelessWidget {
  const HomeCardWidgetBook(
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
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge),
                  Flexible(
                    child: Center(child: child),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
