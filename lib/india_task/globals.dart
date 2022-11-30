// import 'dart:async';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'task.dart';

// Task tempTask;
// Map userData;

// bool showUndoButton = false;
// bool showTaskUndoButton = false;
// ValueNotifier<bool> undoButton = ValueNotifier<bool>(false);
// ValueNotifier<String> taskStatusUndoButton = ValueNotifier<String>("0");
// ValueNotifier<String> newTaskInserted = ValueNotifier<String>("0");
// ValueNotifier<bool> userDataUpdated = ValueNotifier<bool>(false);
// ValueNotifier<bool> userLevelChanged = ValueNotifier<bool>(false);
// Future<void> updateUserPoints(int points) async{
//   int olderLevel = userData['level'];

//   userData['points'] = (userData['points'] ?? 0) + points;
//   userData['level'] =
//       (pow((userData['points'] * 3.6) + 9, (1 / 2)) - 3.5).floor();

//   await FirebaseFirestore.instance.collection("users").doc(userId).update(
//     {
//       "points": userData['points'],
//       "level": userData['level'],
//     },
//   );
//   if (olderLevel < (userData['level'] ?? 0)) {
//     userLevelChanged.value = true;
//     Timer(Duration(seconds: 1), () {
//       userLevelChanged.value = false;
//     });
//   }

//   userDataUpdated.value = !userDataUpdated.value;
// }
