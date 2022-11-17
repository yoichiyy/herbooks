import 'package:counter/counter/count_model.dart';
import 'package:flutter/material.dart';

Widget countArea(String musume) {
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";
  

  return Container(
    margin: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: FutureBuilder<int>(
                future: getCounterForDay(dailyCount, musume),
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
              future: getCounterForMonth(monthlyCount, musume),
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
                future: getCounterForAll(musume),
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

