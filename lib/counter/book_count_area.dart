import 'package:counter/counter/num_count.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget bookCountArea(String musume) {
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";
  final monthlyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}";

  return Container(
    margin: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: FutureBuilder<int>(
                future: NumCountModel().getCounterForDay(dailyCount, musume),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "今日: ${snapshot.data}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                }),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: FutureBuilder<int>(
              future: NumCountModel().getCounterForMonth(monthlyCount, musume),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "今月: ${snapshot.data}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: FutureBuilder<int>(
                // future: getCounterForDay(DateTime.now()),
                future: NumCountModel().fetchReadCountAll(musume),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "全部: ${snapshot.data}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                }),
          ),
        ),
      ],
    ),
  );
}
