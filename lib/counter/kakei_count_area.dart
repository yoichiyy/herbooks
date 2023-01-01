import 'package:counter/counter/num_count.dart';
import 'package:flutter/material.dart';

Widget kakeiCountArea(String oya) {
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day}";
  final monthlyCount = "${DateTime.now().year}${DateTime.now().month}";

  return Container(
    margin: const EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(4),
            child: FutureBuilder<int>(
                future: NumCountModel().getKakeiForDay(dailyCount, oya),
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
              future: NumCountModel().getKakeiForMonth(monthlyCount, oya),
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
                future: NumCountModel().getKakeiForAll(oya),
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
