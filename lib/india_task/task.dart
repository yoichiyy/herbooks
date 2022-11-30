// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import '/Util/util_play_sound.dart';
// import 'globals.dart';

// /*
//     0 : 初期状態
//  ◯  1 : 完了。で記録 // 青グラフ //complete
//  ／ 2 : 今日はやらない。リピートタスクの延期　//緑  //postponed
//   ✕　3 : できませんでした　// 赤 //missed
// -1:Delete
//  */

// class Task {
//   String taskID;
//   String taskName;
//   String taskNote;
//   int uniqueId;
//   Timestamp taskDeadline;
//   Timestamp tempTaskDeadline;
//   String repeatOption;
//   int taskStatus;
//   String customDeadline;
//   bool showInStats;
//   bool taskNoteAccumulative;
//   int taskPoints;
//   String specialNumber;

//   Task({
//     this.taskID,
//     this.taskName,
//     this.taskNote,
//     this.uniqueId,
//     this.taskDeadline,
//     this.repeatOption,
//     this.taskStatus,
//     this.customDeadline,
//     this.tempTaskDeadline,
//     this.showInStats,
//     this.taskNoteAccumulative,
//     this.taskPoints,
//     this.specialNumber,
//   });

//   factory Task.fromJson(QueryDocumentSnapshot document) {
//     Task generatedTask = Task(
//       taskName: document['task_name'] ?? "",
//       taskNote: document['task_note'] ?? "",
//       uniqueId: document['task_unique_id'] ?? 0,
//       taskDeadline: document['task_deadline'] ?? Timestamp.now(),
//       tempTaskDeadline: document['temp_task_deadline'] ?? Timestamp.now(),
//       repeatOption: document['task_repeat'] ?? "",
//       taskID: document.id,
//       customDeadline: "",
//       taskStatus: document['task_status'] ?? 0,
//       showInStats: document['task_show_in_stats'] ?? true,
//       taskNoteAccumulative: document['task_note_acc'] ?? false,
//       taskPoints: document['task_points'] ?? 0,
//       specialNumber: (document['special_number'].toString()) ?? "",
//     );

//     generatedTask.calculateDeadlineCustom();
//     return generatedTask;
//   }

//   Future<String> makeRepeat() async {
//     final firestore = FirebaseFirestore.instance;
//     final taskCollection = firestore.collection("tasks");

//     final newTask = {
//       "task_name": this.taskName,
//       "task_note": (this.taskNoteAccumulative ?? false) ? this.taskNote : "",
//       "task_repeat": this.repeatOption,
//       "task_status": 0,
//       "uid": userId,
//       "task_unique_id": this.uniqueId,
//       "task_show_in_stats": this.showInStats,
//       "task_note_acc": this.taskNoteAccumulative ?? false,
//       "task_points": this.taskPoints,
//       "special_number": this.specialNumber,
//     };
//     if (this.repeatOption == "Repeat Every day") {
//       //そもそも再代入をする必要のない、、、設計を考えるべし
//       var currentTaskTime = DateTime.fromMillisecondsSinceEpoch(
//               this.taskDeadline.millisecondsSinceEpoch)
//           .add(Duration(days: 1));
//       newTask["task_deadline"] = Timestamp.fromDate(currentTaskTime);
//     } else if (this.repeatOption == "Repeat Every weekday") {
//       var currentTaskTime = DateTime.fromMillisecondsSinceEpoch(
//           this.taskDeadline.millisecondsSinceEpoch);
//       int daysTobeAdded;
//       if (currentTaskTime.weekday == 7) {
//         daysTobeAdded = 1;
//       } else if (currentTaskTime.weekday == 6) {
//         daysTobeAdded = 2;
//       } else if (currentTaskTime.weekday == 5) {
//         daysTobeAdded = 3;
//       } else {
//         daysTobeAdded = 1;
//       }
//       currentTaskTime = currentTaskTime.add(Duration(days: daysTobeAdded));

//       newTask["task_deadline"] = Timestamp.fromDate(currentTaskTime);
//     } else if (this.repeatOption == "Repeat Every week") {
//       DateTime currentTaskTime = DateTime.fromMillisecondsSinceEpoch(
//               this.taskDeadline.millisecondsSinceEpoch)
//           .add(
//         Duration(days: 7),
//       );
//       newTask["task_deadline"] = Timestamp.fromDate(currentTaskTime);
//     } else if (this.repeatOption == "Repeat Every Month") {
//       DateTime currentTaskTime = DateTime.fromMillisecondsSinceEpoch(
//           this.taskDeadline.millisecondsSinceEpoch);

//       DateTime newDateTime = DateTime(
//         currentTaskTime.month == 12
//             ? (currentTaskTime.year + 1)
//             : currentTaskTime.year,
//         currentTaskTime.month == 12 ? 1 : currentTaskTime.month + 1,
//         currentTaskTime.day,
//         currentTaskTime.hour,
//         currentTaskTime.minute,
//       );
//       newTask["task_deadline"] = Timestamp.fromDate(newDateTime);
//     }
//     if (newTask.containsKey("task_deadline")) {
//       newTask['temp_task_deadline'] = newTask["task_deadline"];

//       final taskAdded = //addedTaskReferenceなど、よりわかり易い名前に。
//           await taskCollection.add(Map.castFrom(newTask));

//       return taskAdded.id;
//     } else {
//       return '0';
//     }
//   }

//   calculateDeadlineCustom() {
//     DateTime deadline = this.tempTaskDeadline.toDate();
//     DateTime now = DateTime.now();
// //1日よりも前ならば、◯日前と表示
//     if (deadline.difference(now).inDays <= -1) {
//       this.customDeadline =
//           now.difference(deadline).inDays.toString() + " Days Ago";
// //1日前より新しく、4時間前より昔ならば
//     } else if (deadline.difference(now).inDays > -1 &&
//         deadline.difference(now).inHours <= -1) {
//       this.customDeadline =
//           now.difference(deadline).inHours.toString() + " Hours Ago";
// //－４より右だが、－１より左
//     } else if (deadline.difference(now).inHours > -1 &&
//         deadline.isBefore(now)) {
//       this.customDeadline =
//           now.difference(deadline).inMinutes.toString() + " Minutes Ago";
//     } else if (deadline.difference(now).inMinutes <= 60) {
//       this.customDeadline =
//           deadline.difference(now).inMinutes.toString() + " Minutes Left";
//     } else if (deadline.difference(now).inHours >= 1 &&
//         deadline.difference(now).inHours <= 4) {
//       this.customDeadline =
//           deadline.difference(now).inHours.toString() + " Hours Left";
//     } else if (deadline.difference(now).inHours > 4 &&
//         deadline.difference(now).inHours <= 24) {
//       this.customDeadline =
//           DateFormat(DateFormat.HOUR24_MINUTE).format(deadline);
//     } else if (deadline.difference(now).inDays > 1 &&
//         deadline.difference(now).inDays <= 7) {
//       this.customDeadline = DateFormat('EEEE').format(deadline);
//     } else {
//       this.customDeadline = "${deadline.month}/${deadline.day}";
//     }
//   }

//   Future<void> updateTaskStatusAndPlaySound(int status, audioCache) async {
//     UtilPlaySound().playSound(status, audioCache);

//     await FirebaseFirestore.instance
//         .collection("tasks")
//         .doc(this.taskID)
//         .update(
//       {"task_status": status},
//     );
//     taskStatusUndoButton.value = this.taskID;

//     if (status == 1) {
//       //1.関数は頭に必ずかたつけろ
//       //2.if のかっこいい敵書き方は、推奨されぬ。リントをいれるならば。
//       await updateUserPoints(this.taskPoints);
//     }

//     newTaskInserted.value = await this.makeRepeat();
//     if (this.specialNumber != "") {
//       await APIS.addEntryInSheet(
//         taskID: this.specialNumber,
//         taskStatus: status,
//         note: this.taskNote,
//         points: this.taskPoints,
//         taskName: this.taskName,
//         due: this.taskDeadline.toDate(),
//       );
//     }
//   }

//   void updateTaskStatusUsingId(String taskId, status) async {
//     DocumentSnapshot snapShot =
//         await FirebaseFirestore.instance.collection("tasks").doc(taskId).get();
//     Map taskData = snapShot.data();
//     if (taskData['task_status'] == 1)
//       updateUserPoints(-(taskData['task_points'] ?? 0));

//     FirebaseFirestore.instance.collection("tasks").doc(taskId).update(
//       {"task_status": status},
//     );
//   }

//   void updateStatusForTaskTHroughUniqueID(int uniqueId, bool stats) async {
//     CollectionReference taskCollection =
//         FirebaseFirestore.instance.collection("tasks");

//     QuerySnapshot snapShot =
//         await taskCollection.where("task_unique_id", isEqualTo: uniqueId).get();
//     List<QueryDocumentSnapshot> data = snapShot.docs;

//     data.forEach((element) {
//       Task t = Task.fromJson(element);
//       taskCollection.doc(t.taskID).update({"task_show_in_stats": stats});
//     });
//   }

//   void DeleteForTaskTHroughUniqueID(int uniqueId) async {
//     CollectionReference taskCollection =
//         FirebaseFirestore.instance.collection("tasks");

//     QuerySnapshot snapShot =
//         await taskCollection.where("task_unique_id", isEqualTo: uniqueId).get();
//     List<QueryDocumentSnapshot> data = snapShot.docs;

//     data.forEach((element) {
//       Task t = Task.fromJson(element);
//       taskCollection.doc(t.taskID).update({"task_status": -1});
//     });
//   }
// }
