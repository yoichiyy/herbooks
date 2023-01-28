import 'package:counter/counter/num_count.dart';
import 'package:flutter/material.dart';

class HomeCardWidgetBook extends StatelessWidget {
  HomeCardWidgetBook(
      {Key? key,
      required this.color,
      required this.title,
      required this.musume,
      required this.buttonWidget})
      : super(key: key);

  final Color color;
  final String title;
  final String musume;
  final Widget buttonWidget;
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  FutureBuilder<int>(
                      future:
                          NumCountModel().getCounterForDay(dailyCount, musume),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      }),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Center(child: buttonWidget),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
