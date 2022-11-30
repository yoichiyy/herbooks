// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import '/Util/util_time_calc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'globals.dart';
// import 'task.dart';
// import 'notifications.dart';
// import 'settings.dart';




// class PageTaskEdit extends StatefulWidget {
//   Task taskEdit;
//   bool edit;

//   PageTaskEdit({
//     this.taskEdit,
//     this.edit = false,
//   });
//   @override
//   _PageTaskEditState createState() => _PageTaskEditState();
// }

// class _PageTaskEditState extends State<PageTaskEdit> {
//   TimeOfDay time1 = const TimeOfDay(hour: 12, minute: 10);
//   TimeOfDay time2 = const TimeOfDay(hour: 12, minute: 10);
//   TimeOfDay time3 = const TimeOfDay(hour: 12, minute: 10);
//   TimeOfDay time4 = const TimeOfDay(hour: 12, minute: 10);
//   AudioCache _audioCacheEdit;

//   bool isLoading = true;

//   Color bgColor = const Color.fromRGBO(3, 7, 47, 1);
//   DateTime taskDeadline = DateTime.now();

//   // bool isRepeated = false;
//   String selectedRepeatOption = "Repeat Every day";
//   int selectedNumber;
//   int selectedPoints = 1;
//   String selectedSpecialtaskId = "";
//   String selectedDMW;
//   bool showInStats = userData['defaultStats'] ?? false;
//   bool showNoteField = userData['defaultNote'] ?? true;
//   bool showAccNoteField = userData['defaultAccNote'] ?? true;
//   bool showSlider = userData['defaultSlider'] ?? true;

//   bool taskNoteAccumulative = false;
//   bool showAdvancedOptions = false;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference taskCollection;

//   CollectionReference userCollection;
//   TextEditingController taskNameController = TextEditingController();
//   TextEditingController taskNoteController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _audioCacheEdit = AudioCache(
//         prefix: 'assets/audio/',
//         fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
//     taskCollection = firestore.collection("tasks");
//     if (widget.edit) {
//       taskDeadline = DateTime.fromMillisecondsSinceEpoch(
//           widget.taskEdit.tempTaskDeadline.millisecondsSinceEpoch);
//       taskNameController.text = widget.taskEdit.taskName;
//       taskNoteController.text = widget.taskEdit.taskNote;
//       selectedRepeatOption = widget.taskEdit.repeatOption;
//       showInStats = widget.taskEdit.showInStats;
//       taskNoteAccumulative = widget.taskEdit.taskNoteAccumulative;
//       selectedPoints = widget.taskEdit.taskPoints;
//       selectedSpecialtaskId = widget.taskEdit.specialNumber;
//     }

//     get();
//   }

//   get() async {
//     userCollection = firestore.collection("users");

//     DocumentSnapshot snapShot = await userCollection.doc(userId).get();

//     Map data = snapShot.data();
//     if (data.isNotEmpty) {
//       time1 = fromString(data['time1'] ?? "00:00");
//       time2 = fromString(data['time2'] ?? "00:00");
//       time3 = fromString(data['time3'] ?? "00:00");
//       time4 = fromString(data['time4'] ?? "00:00");
//       // showInStats = data['defaultStats'] ?? true;
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

// //タスク登録機能
//   _handleSaveTask() async {
//     //既存のタスクが、editされていて、かつリピートタスクだった場合、今後のリピートもそうするか確認する
//     if (widget.edit) {
//       bool userInput = false;

//       if (selectedRepeatOption != "Repeat Off" &&
//           widget.taskEdit.taskDeadline.toDate() != taskDeadline) {
//         userInput = await showDialog(
//           context: context,
//           builder: (context) {
//             return SimpleDialog(
//               title: const Text("Do you want to change the time for?"),
//               children: [
//                 SimpleDialogOption(
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("Today Only"),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                 ),
//                 SimpleDialogOption(
//                   child: const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text("All Future Occurences"),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       }
//       tempTask = widget.taskEdit;
//       //ここのif elseは、違いがないようだ
//       if (userInput == false) {
//         taskCollection.doc(widget.taskEdit.taskID).update(
//           {
//             "task_name": taskNameController.text.trim(),
//             "task_note": taskNoteController.text.trim(),
//             "task_deadline": taskDeadline ?? DateTime.now(),
//             "temp_task_deadline": taskDeadline ?? DateTime.now(),
//             "task_repeat": selectedRepeatOption,
//             "task_status": widget.taskEdit.taskStatus,
//             "uid": userId,
//             "task_unique_id": widget.taskEdit.uniqueId,
//             "task_show_in_stats": showInStats,
//             "task_note_acc": taskNoteAccumulative,
//             "task_points": selectedPoints,
//             "special_number": selectedSpecialtaskId,
//           },
//         );
//       } else {
//         taskCollection.doc(widget.taskEdit.taskID).update({
//           "task_name": taskNameController.text.trim(),
//           "task_note": taskNoteController.text.trim(),
//           "task_deadline": widget.taskEdit.taskDeadline ?? DateTime.now(),
//           "temp_task_deadline": taskDeadline ?? DateTime.now(),
//           "task_repeat": selectedRepeatOption,
//           "task_status": widget.taskEdit.taskStatus,
//           "uid": userId,
//           "task_unique_id": widget.taskEdit.uniqueId,
//           "task_show_in_stats": showInStats,
//           "task_note_acc": taskNoteAccumulative,
//           "task_points": selectedPoints,
//           "special_number": selectedSpecialtaskId,
//         });
//       }

//       Task().updateStatusForTaskTHroughUniqueID(
//         widget.taskEdit.uniqueId,
//         showInStats,
//       );
//       showUndoButton = true;
//       undoButton.value = !undoButton.value;
//     } else {
//       taskCollection.add(
//         {
//           "task_name": taskNameController.text.trim(),
//           "task_note": taskNoteController.text.trim(),
//           "task_deadline": taskDeadline ?? DateTime.now(),
//           "temp_task_deadline": taskDeadline ?? DateTime.now(),
//           "task_repeat": selectedRepeatOption,
//           "task_status": 0,
//           "uid": userId,
//           "task_unique_id": int.parse(
//             DateFormat("yyyyMMddHHmmss").format(taskDeadline),
//           ),
//           "task_show_in_stats": showInStats,
//           "task_note_acc": taskNoteAccumulative,
//           "task_points": selectedPoints,
//           "special_number": selectedSpecialtaskId,
//         },
//       );
//     }

//     // After saving to firebase or taskCollection - [taskDeadline]
//     // ２つ合わせたものがこっち
//     notificationPlugin.scheduleRepeatNotification(
//         taskNameController.text.trim(), taskDeadline);

//     // notificationPlugin.scheduleNotification(//snoozeしない場合はこっち
//     // await notificationPlugin.scheduleNotification(
//     //     taskNameController.text.trim(), taskDeadline);

//     // //リピートはこっち
//     // await notificationPlugin.repeatNotification("通知", taskNameController.text.trim(),
//     //     int.parse(taskDeadline.toString()));
//   }

//   _handleExitTap() async {
//     if (widget.edit &&
//         ((widget.taskEdit.taskName != taskNameController.text.trim()) ||
//             (widget.taskEdit.taskNote != taskNoteController.text.trim()) ||
//             !(widget.taskEdit.tempTaskDeadline.toDate() == taskDeadline ||
//                 widget.taskEdit.taskDeadline.toDate() == taskDeadline))) {
//       bool userInput = await showDialog(
//         context: context,
//         builder: (context) {
//           return SimpleDialog(
//             title: const Text("Are you sure you want to discard the changes?"),
//             children: [
//               SimpleDialogOption(
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text("Yes"),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//               ),
//               SimpleDialogOption(
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text("No"),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//               )
//             ],
//           );
//         },
//       );
//       if (userInput) Navigator.pop(context);
//     } else {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : WillPopScope(
//             onWillPop: () async {
//               await _handleSaveTask();
//               return true;
//             },
//             child: Scaffold(
//               resizeToAvoidBottomInset: true,
//               body: Stack(
//                 children: [
//                   InkWell(
//                     onTap: _handleExitTap,
//                     child: Container(
//                       color: Colors.orange[700],
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.center,
//                     child: Container(
//                       padding:
//                           const EdgeInsets.only(left: 30, right: 30), //四角の右と左に広がらぬよう
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min, //カラム内で中央に配置
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               _iconButton(
//                                 Icons.highlight_off,
//                                 _handleExitTap,
//                               ),
//                               _iconButton(
//                                 Icons.delete,
//                                 () async {
//                                   if (widget.edit) {
//                                     //2-1: 完了処理
//                                     await showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: const Text(
//                                             "You want to delete this task?"),
//                                         actions: [
//                                           TextButton(
//                                             child: const Text("Yes"),
//                                             onPressed: () {
//                                               FirebaseFirestore.instance
//                                                   .collection("tasks")
//                                                   .doc(widget.taskEdit.taskID)
//                                                   .update(
//                                                 {"task_status": -1},
//                                               );
//                                               Navigator.pop(context);
//                                               Navigator.pop(context);
//                                             },
//                                           ),
//                                           TextButton(
//                                             child: const Text("No"),
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                           )
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                               widget.edit
//                                   ? _iconButton(
//                                       Icons.details,
//                                       () async {
//                                         Navigator.of(context)
//                                             .push(MaterialPageRoute(
//                                           builder: (context) =>
//                                               TaskDetailedNote(
//                                             primaryTaskUniqueId:
//                                                 widget.taskEdit.uniqueId,
//                                           ),
//                                         ));
//                                       },
//                                     )
//                                   : const SizedBox(),
//                               _iconButton(
//                                 Icons.loop,
//                                 () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => SimpleDialog(
//                                       title: Container(
//                                         child: const Text("Select Repeat Option"),
//                                       ),
//                                       children: [
//                                         'Repeat Off',
//                                         'Repeat Every day',
//                                         'Repeat Every weekday',
//                                         'Repeat Every week',
//                                         'Repeat Every Month',
//                                         'Custom Repeat',
//                                       ]
//                                           .map((e) => SimpleDialogOption(
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Text(
//                                                     e == "Repeat Every week"
//                                                         ? e +
//                                                             " (${DateFormat('EEE').format(DateTime.now())})"
//                                                         : e,
//                                                     style: TextStyle(
//                                                       color:
//                                                           selectedRepeatOption ==
//                                                                   e
//                                                               ? Colors.green
//                                                               : Colors.black,
//                                                       fontWeight:
//                                                           selectedRepeatOption ==
//                                                                   e
//                                                               ? FontWeight.bold
//                                                               : FontWeight
//                                                                   .normal,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   Navigator.pop(context);
//                                                   setState(() {
//                                                     selectedRepeatOption = e;
//                                                   });

//                                                   if (e == "Custom Repeat") {
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (context) =>
//                                                           Dialog(
//                                                         child: Column(
//                                                           mainAxisSize:
//                                                               MainAxisSize.min,
//                                                           children: [
//                                                             const Padding(
//                                                               padding:
//                                                                   EdgeInsets
//                                                                       .all(8.0),
//                                                               child: Text(
//                                                                   "Select Custom Repeat Option"),
//                                                             ),
//                                                             DropdownButton<int>(
//                                                               items: [
//                                                                 1,
//                                                                 2,
//                                                                 3,
//                                                                 4,
//                                                                 5,
//                                                                 6,
//                                                                 7,
//                                                                 8,
//                                                                 9,
//                                                                 10
//                                                               ]
//                                                                   .map((e) =>
//                                                                       DropdownMenuItem(
//                                                                         child: Text(
//                                                                             "$e"),
//                                                                         value:
//                                                                             e,
//                                                                       ))
//                                                                   .toList(),
//                                                               hint: const Text(
//                                                                   "Select Number of Days"),
//                                                               value:
//                                                                   selectedNumber,
//                                                               onChanged:
//                                                                   (value) {
//                                                                 setState(() {
//                                                                   selectedNumber =
//                                                                       value;
//                                                                 });
//                                                               },
//                                                             ),
//                                                             DropdownButton<
//                                                                 String>(
//                                                               items: [
//                                                                 "Day(s)",
//                                                                 "Week(s)",
//                                                                 "Month(s)"
//                                                               ]
//                                                                   .map((e) =>
//                                                                       DropdownMenuItem(
//                                                                         child: Text(
//                                                                             "$e"),
//                                                                         value:
//                                                                             e,
//                                                                       ))
//                                                                   .toList(),
//                                                               hint: const Text(
//                                                                   "Select Option"),
//                                                               value:
//                                                                   selectedDMW,
//                                                               onChanged:
//                                                                   (value) {
//                                                                 setState(() {
//                                                                   selectedDMW =
//                                                                       value;
//                                                                 });
//                                                               },
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }
//                                                 },
//                                               ))
//                                           .toList(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               //タスク名　入力欄
//                               _iconButton(
//                                 Icons.play_circle_outline,
//                                 () async {
//                                   await _handleSaveTask();
//                                   Navigator.pop(context);
//                                 },
//                               ),
//                             ],
//                           ),
//                           //タスク名　入力欄
//                           _inputTaskName(
//                             controller: taskNameController,
//                             autofocus: false,
//                           ),
//                           const Divider(
//                             color: Colors.black,
//                             height: 1,
//                           ),
//                           (userData['level'] ?? 0) < 4
//                               ? const SizedBox()
//                               : showNoteField
//                                   ? _inputTaskName(
//                                       controller: taskNoteController,
//                                       hint: "Enter Note",
//                                     )
//                                   : const SizedBox(),
//                           (userData['level'] ?? 0) < 4
//                               ? const SizedBox()
//                               : showNoteField
//                                   ? const Divider(
//                                       color: Colors.black,
//                                       height: 1,
//                                     )
//                                   : const SizedBox(),
//                           _showDeadline(),
//                           const Divider(
//                             color: Colors.black,
//                             height: 1,
//                           ),
//                           _table(),
//                           const Divider(
//                             color: Colors.black,
//                             height: 1,
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                             children: [
//                               const Text("Advanced Options"),
//                               const Spacer(),
//                               Switch(
//                                 value: showAdvancedOptions,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     showAdvancedOptions = val;
//                                   });
//                                   FocusScope.of(context).unfocus();
//                                 },
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Column(
//                             children: [
//                               !showAdvancedOptions
//                                   ? const SizedBox()
//                                   : TextFormField(
//                                       initialValue: selectedSpecialtaskId,
//                                       onChanged: (s) {
//                                         selectedSpecialtaskId = s;
//                                       },
//                                       decoration: const InputDecoration(
//                                           hintText: "Special Task"),
//                                     ),
//                               (userData['level'] ?? 0) < 8
//                                   ? const SizedBox()
//                                   : showSlider
//                                       ? Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Padding(
//                                               padding:
//                                                   EdgeInsets.all(8.0),
//                                               child: Text("Points"),
//                                             ),
//                                             Slider(
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   selectedPoints =
//                                                       value.toInt();
//                                                 });
//                                               },
//                                               value: selectedPoints.toDouble(),
//                                               max: 5,
//                                               min: 0,
//                                               activeColor: Colors.white,
//                                               inactiveColor: Colors.black,
//                                               divisions: 5,
//                                               label: "$selectedPoints",
//                                             ),
//                                           ],
//                                         )
//                                       : const SizedBox(),
//                               _showStatsCheckBox(
//                                   value: showInStats,
//                                   onChanged: (v) {
//                                     setState(() {
//                                       showInStats = v;
//                                     });
//                                   }),
//                               (userData['level'] ?? 0) < 3
//                                   ? const SizedBox()
//                                   : const Divider(
//                                       color: Colors.black,
//                                       height: 1,
//                                     ),
//                               (userData['level'] ?? 0) < 5
//                                   ? const SizedBox()
//                                   : showAccNoteField
//                                       ? _showYaskNoteAccCheckBox(
//                                           value: taskNoteAccumulative,
//                                           onChanged: (v) {
//                                             setState(() {
//                                               taskNoteAccumulative = v;
//                                             });
//                                           },
//                                         )
//                                       : const SizedBox(),
//                             ],
//                           ),
//                         ], //children
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }

//   Widget _iconButton(IconData icon, VoidCallback function) {
//     return IconButton(
//       iconSize: 50,
//       icon: Icon(
//         icon,
//         color: Colors.white,
//       ),
//       onPressed: function,
//     );
//   }

//   Widget _inputTaskName({
//     controller,
//     hint,
//     autofocus,
//   }) {
//     return Container(
//       padding: const EdgeInsets.only(left: 5, right: 5),
//       color: Colors.white,
//       child: TextFormField(
//         controller: controller,
//         maxLines: 4,
//         minLines: 1,
//         autofocus: autofocus ?? false,
//         keyboardType: TextInputType.multiline,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: hint ?? 'Input name',
//         ),
//       ),
//     );
//   }

//   Widget _showStatsCheckBox({value, onChanged}) {
//     return Container(
//       padding: const EdgeInsets.only(left: 5, right: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         // border: Border.all(
//         //   color: Colors.white,
//         //   width: 2.5,
//         // ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Checkbox(
//             onChanged: onChanged,
//             value: value,
//           ),
//           const Text("Show in Statistics Page")
//         ],
//       ),
//     );
//   }

//   Widget _showYaskNoteAccCheckBox({value, onChanged}) {
//     return Container(
//       padding: const EdgeInsets.only(left: 5, right: 5),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         // border: Border.all(
//         //   color: Colors.white,
//         //   width: 2.5,
//         // ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Checkbox(
//             onChanged: onChanged,
//             value: value,
//           ),
//           const Text("Accumulate Note")
//         ],
//       ),
//     );
//   }
//   // dynamic date = Datetime(2021, DateTime.march, 18);
//   // DateFormat.MMMMEEEEd().add_jms().format(date);

//   // 日時を指定したフォーマットで指定するためのフォーマッター
//   var dateTimeFormatter = DateFormat('MM月dd日(E) HH:mm', "ja_JP");
//   var timeFormatter = DateFormat('HH:mm', "ja_JP");

//   Widget _showDeadline() {
//     return GestureDetector(
//       onTap: () {
//         // 期日を設けることのできるタグの時のみ、showDateTimePickerを呼び出す
//         DatePicker.showDateTimePicker(
//           context, showTitleActions: true,
//           // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
//           onChanged: (date) {
//             // print('change $date');
//           },
//           // onConfirm内の処理はDatepickerで選択完了後に呼び出される
//           onConfirm: (date) {
//             setState(() {
//               taskDeadline = date;
//             });
//           },
//           // Datepickerのデフォルトで表示する日時
//           currentTime: taskDeadline,
//           // localによって色々な言語に対応
//           //  locale: LocaleType.en
//           locale: LocaleType.jp,
//         );
//       },
//       child: Container(
//         color: DateTime.now().compareTo(taskDeadline) < 0
//             ? const Color.fromRGBO(190, 200, 210, 1)
//             : Colors.red,
//         padding: const EdgeInsets.all(5),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       dateTimeFormatter.format(taskDeadline),
//                       style: TextStyle(
//                         color: DateTime.now().compareTo(taskDeadline) < 0
//                             ? const Color.fromRGBO(150, 150, 150, 1)
//                             : Colors.white,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       (DateTime.now().millisecondsSinceEpoch <
//                               taskDeadline.millisecondsSinceEpoch)
//                           ? UtilTimeCalc().fromAtNow(taskDeadline)
//                           : "",
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "$selectedRepeatOption",
//                   style: TextStyle(
//                     color: DateTime.now().compareTo(taskDeadline) < 0
//                         ? const Color.fromRGBO(150, 150, 150, 1)
//                         : Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _table() {
//     return Table(
//       border: const TableBorder(
//         horizontalInside: BorderSide(
//           color: Colors.black,
//           width: 0.5,
//         ),
//         verticalInside: BorderSide(
//           color: Colors.black,
//           width: 0.5,
//         ),
//       ),
//       children: [
//         TableRow(children: [
//           _tableCell2(time1.format(context), time1),
//           _tableCell2(time2.format(context), time2),
//           _tableCell2(time3.format(context), time3),
//           _tableCell2(time4.format(context), time4),
//         ]),
//         TableRow(children: [
//           _tableCell("+10分", const Duration(minutes: 10)),
//           _tableCell("+1時間", const Duration(hours: 1)),
//           _tableCell("+3時間", const Duration(hours: 3)),
//           _tableCell("+1日", const Duration(days: 1)),
//         ]),
//         TableRow(children: [
//           _tableCell("-10分", const Duration(minutes: -10)),
//           _tableCell("-1時間", const Duration(hours: -1)),
//           _tableCell("-3時間", const Duration(hours: -3)),
//           _tableCell("-1日", const Duration(days: -1)),
//         ]),
//       ],
//     );
//   }

//   Widget _tableCell(String text, Duration duration) {
//     return Container(
//       height: 40,
//       child: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.white),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.black,
//           ),
//         ),
//         onPressed: () {
//           setState(() {
//             if (taskDeadline.compareTo(DateTime.now()) < 0) {
//               taskDeadline = DateTime.now().add(duration);
//             } else {
//               taskDeadline = taskDeadline.add(duration);
//             }
//           });
//         },
//       ),
//     );
//   }

//   Widget _tableCell2(String text, TimeOfDay time) {
//     return Container(
//       height: 40,
//       child: ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.white),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.black,
//           ),
//         ),
//         onPressed: () {
//           setState(
//             () {
//               DateTime newTime = DateTime(taskDeadline.year, taskDeadline.month,
//                   taskDeadline.day, time.hour, time.minute);

//               if (newTime.compareTo(taskDeadline) < 0) {
//                 taskDeadline = taskDeadline.add(const Duration(days: 1));
//                 taskDeadline = DateTime(taskDeadline.year, taskDeadline.month,
//                     taskDeadline.day, time.hour, time.minute);
//               } else {
//                 taskDeadline = newTime;
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
