// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '/Util/util_prefs.dart';
// import 'globals.dart';
// import 'package:toast/toast.dart';

// TimeOfDay fromString(String time) {
//   int hour = int.parse(time.split(":").first);
//   int min = int.parse(time.split(":").last);
//   return TimeOfDay(hour: hour, minute: min);
// }

// class Settings extends StatefulWidget {
//   @override
//   _SettingsState createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   TimeOfDay time1 = TimeOfDay(hour: 12, minute: 10);

//   TimeOfDay time2 = TimeOfDay(hour: 12, minute: 10);

//   TimeOfDay time3 = TimeOfDay(hour: 12, minute: 10);

//   TimeOfDay time4 = TimeOfDay(hour: 12, minute: 10);
//   TextEditingController _transferPointsController = TextEditingController();
//   TextEditingController _transferPersonController = TextEditingController();
//   String _transferPerson;
//   List userRecommendationList = [];

//   TextEditingController _bagdeNameController = TextEditingController();
//   TextEditingController _bagdePersonController = TextEditingController();
//   bool _showStatsSettings = false;
//   bool _showAccNoteSettings = false;
//   bool _showNoteSettings = false;
//   bool _showSliderSettings = false;
//   bool _joinCommunity = false;
//   bool _fabLeft = false;

//   FirebaseFirestore firestore;
//   CollectionReference userCollection;
//   bool isLoading = true;

//   @override
//   void initState() {
//     get();
//     super.initState();
//   }

//   get() async {
//     firestore = FirebaseFirestore.instance;
//     userCollection = firestore.collection("users");
//     userRecommendationList = readUserList();

//     if (userRecommendationList.isNotEmpty) {
//       Set users = new Set();
//       users.addAll(userRecommendationList);
//       userRecommendationList = users.toList();
//     }

//     DocumentSnapshot snapShot = await userCollection.doc(userId).get();

//     Map data = snapShot.data();
//     if (data.isNotEmpty) {
//       time1 = fromString(data['time1'] ?? "00:00");
//       time2 = fromString(data['time2'] ?? "00:00");
//       time3 = fromString(data['time3'] ?? "00:00");
//       time4 = fromString(data['time4'] ?? "00:00");
//       _joinCommunity = data['joinCommunity'] ?? false;
//       _showStatsSettings = data['defaultStats'] ?? true;
//       _showAccNoteSettings = data['defaultAccNote'] ?? true;
//       _showNoteSettings = data['defaultNote'] ?? true;
//       _showSliderSettings = data['defaultSlider'] ?? true;
//       _fabLeft = data['fabLeft'] ?? false;
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   _handleTransferPoints() async {
//     String email = _transferPersonController.text.trim();
//     int points = int.tryParse(_transferPointsController.text.trim());

//     if (email != "" || (points ?? 0) != 0) {
//       if (points <= userData['level']) {
//         QuerySnapshot snapShot =
//             await userCollection.where("username", isEqualTo: email).get();
//         if (snapShot.docs.isNotEmpty) {
//           QueryDocumentSnapshot _transferUser = snapShot.docs.first;
//           Map _transferUserData = _transferUser.data();

//           _transferUserData['points'] =
//               (_transferUserData['points'] ?? 0) + points;

//           FirebaseFirestore.instance
//               .collection("users")
//               .doc(_transferUser.id)
//               .update(
//             {
//               "points": _transferUserData['points'],
//               "level": pow(_transferUserData['points'], (1 / 3)).floor(),
//             },
//           );
//           storeUserList(email);
//           Toast.show(
//             "Transfer Sucess",
//             context,
//             backgroundColor: Colors.green,
//             gravity: 1,
//             duration: 3,
//           );
//           updateUserPoints(-points);
//           _transferPersonController.clear();
//           _transferPointsController.clear();
//         } else {
//           Toast.show(
//             "No such user found",
//             context,
//             backgroundColor: Colors.red,
//             gravity: 1,
//             duration: 3,
//           );
//         }
//       } else {
//         Toast.show(
//           "You cannot transfer the points greater than your level",
//           context,
//           backgroundColor: Colors.yellow,
//           gravity: 1,
//           duration: 3,
//         );
//       }
//     } else {
//       Toast.show(
//         "Please Enter all the parameters",
//         context,
//         backgroundColor: Colors.orange,
//         gravity: 1,
//         duration: 3,
//       );
//     }
//   }

//   _handleMenuTap() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           insetPadding: EdgeInsets.all(0),
//           contentPadding: EdgeInsets.all(0),
//           content: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height / 2,
//             child: userRecommendationList.isEmpty
//                 ? Center(child: Text("No Users Added"))
//                 : ListView.builder(
//                     itemCount: userRecommendationList.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: InkWell(
//                           onTap: () {
//                             _transferPersonController.text =
//                                 userRecommendationList.elementAt(index);
//                             setState(() {});
//                             Navigator.pop(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               userRecommendationList.elementAt(index),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         );
//       },
//     );
//   }

//   _handleGiveBadgePoints() async {
//     String email = _bagdePersonController.text.trim();
//     String badge = _bagdeNameController.text.trim();

//     if (email != "" && badge != "") {
//       QuerySnapshot snapShot =
//           await userCollection.where("username", isEqualTo: email).get();
//       if (snapShot.docs.isNotEmpty) {
//         QueryDocumentSnapshot _transferUser = snapShot.docs.first;
//         Map _transferUserData = _transferUser.data();

//         _transferUserData['badge'] =
//             (_transferUserData['badge'] ?? '') + " " + badge;

//         FirebaseFirestore.instance
//             .collection("users")
//             .doc(_transferUser.id)
//             .update(
//           {
//             "badge": _transferUserData['badge'],
//           },
//         );
//         storeUserList(email);
//         Toast.show(
//           "Transfer Sucess",
//           context,
//           backgroundColor: Colors.green,
//           gravity: 1,
//           duration: 3,
//         );

//         _bagdePersonController.clear();
//         _bagdeNameController.clear();
//       } else {
//         Toast.show(
//           "No such user found",
//           context,
//           backgroundColor: Colors.red,
//           gravity: 1,
//           duration: 3,
//         );
//       }
//     } else {
//       Toast.show(
//         "Please Enter all the parameters",
//         context,
//         backgroundColor: Colors.yellow,
//         gravity: 1,
//         duration: 3,
//       );
//     }
//   }

//   _handleJoinCommunity(val) {
//     setState(() {
//       _joinCommunity = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleStatsCheckbox(val) {
//     setState(() {
//       _showStatsSettings = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleNoteCheckbox(val) {
//     setState(() {
//       _showNoteSettings = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleAccNoteCheckbox(val) {
//     setState(() {
//       _showAccNoteSettings = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleSliderCheckbox(val) {
//     setState(() {
//       _showSliderSettings = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleFABCheckbox(val) {
//     setState(() {
//       _fabLeft = val;
//     });
//     _handleSaveButtonPushed();
//   }

//   _handleDeleteAllTasks() async {
//     Navigator.pop(context);
//     setState(() {
//       isLoading = true;
//     });
//     CollectionReference taskCollection = firestore.collection("tasks");
//     QuerySnapshot snapshotData =
//         await taskCollection.where("uid", isEqualTo: userId).get();
//     print(snapshotData.docs.length);
//     snapshotData.docs.forEach((element) {
//       taskCollection.doc(element.id).delete();
//     });
//     userCollection.doc(userId).update({'selectedInStats': []});
//     ;
//     setState(() {
//       isLoading = false;
//     });
//     Toast.show(
//       'All Tasks Deleted',
//       context,
//     );
//   }

//   _handleSaveButtonPushed() {
//     userCollection.doc(userId).update({
//       "time1": "${time1.hour}:${time1.minute}",
//       "time2": "${time2.hour}:${time2.minute}",
//       "time3": "${time3.hour}:${time3.minute}",
//       "time4": "${time4.hour}:${time4.minute}",
//       "joinCommunity": _joinCommunity,
//       "defaultStats": _showStatsSettings,
//       "defaultAccNote": _showAccNoteSettings,
//       "defaultNote": _showNoteSettings,
//       "defaultSlider": _showSliderSettings,
//       "fabLeft": _fabLeft,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("セッティング"),
//         actions: [
//           InkWell(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => OnboardingScreen(),
//               ));
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Icon(Icons.help),
//             ),
//           )
//         ],
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   bar("クイックアクセスタイムの設定"),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TimeDisplay(
//                         onClick: (val) {
//                           setState(() {
//                             time1 = val;
//                           });
//                           _handleSaveButtonPushed();
//                         },
//                         time: time1,
//                       ),
//                       TimeDisplay(
//                         onClick: (val) {
//                           setState(() {
//                             time2 = val;
//                           });
//                           _handleSaveButtonPushed();
//                         },
//                         time: time2,
//                       ),
//                       TimeDisplay(
//                         onClick: (val) {
//                           setState(() {
//                             time3 = val;
//                           });
//                           _handleSaveButtonPushed();
//                         },
//                         time: time3,
//                       ),
//                       TimeDisplay(
//                         onClick: (val) {
//                           setState(() {
//                             time4 = val;
//                           });
//                           _handleSaveButtonPushed();
//                         },
//                         time: time4,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all<Color>(Colors.red),
//                         ),
//                         onPressed: () async {
//                           await showDialog(
//                             context: context,
//                             builder: (context) => AlertDialog(
//                               title: Text("すべてのタスクを削除しますか？"),
//                               actions: [
//                                 TextButton(
//                                   child: Text("Yes"),
//                                   onPressed: _handleDeleteAllTasks,
//                                 ),
//                                 TextButton(
//                                   child: Text("No"),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                         child: Text("すべてのタスクを削除"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await makeUserLogOut();
//                           Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                 builder: (context) => LoginPage(useEmail: true),
//                               ),
//                               (route) => false);
//                         },
//                         child: Text("ログイン"),
//                       ),
//                     ],
//                   ),
//                   bar("その他設定"),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Checkbox(
//                         value: _fabLeft,
//                         onChanged: _handleFABCheckbox,
//                       ),
//                       Text("”作成ボタン”を左下へ移動"),
//                     ],
//                   ),
//                   (userData['level'] ?? 0) < 3
//                       ? SizedBox()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: _showStatsSettings,
//                               onChanged: _handleStatsCheckbox,
//                             ),
//                             Text("作成したタスクを統計ページで表示"),
//                           ],
//                         ),
//                   (userData['level'] ?? 0) < 4
//                       ? SizedBox()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: _showNoteSettings,
//                               onChanged: _handleNoteCheckbox,
//                             ),
//                             Text("ノート入力欄を表示する"),
//                           ],
//                         ),
//                   (userData['level'] ?? 0) < 5
//                       ? SizedBox()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: _showAccNoteSettings,
//                               onChanged: _handleAccNoteCheckbox,
//                             ),
//                             Text("「累積ノート」チェックボタンを表示"),
//                           ],
//                         ),
//                   (userData['level'] ?? 0) < 8
//                       ? SizedBox()
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Checkbox(
//                               value: _showSliderSettings,
//                               onChanged: _handleSliderCheckbox,
//                             ),
//                             Text("「ポイント調整スライダー」を有効にする"),
//                           ],
//                         ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _joinCommunity,
//                             onChanged: _handleJoinCommunity,
//                           ),
//                           Text("ランキングに参加する"),
//                         ],
//                       ),
//                       _joinCommunity
//                           ? TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => RankingPage()));
//                               },
//                               child: Text("ランキングページ"),
//                             )
//                           : SizedBox()
//                     ],
//                   ),
//                   bar("ポイントを渡す"),
//                   _buildTransferPoint(),

//                   (userData['level'] ?? 0) < 10
//                       ? SizedBox()
//                       : bar("Give Badge"),
//                   (userData['level'] ?? 0) < 10
//                       ? SizedBox()
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText: "Badge",
//                                   border: InputBorder.none,
//                                 ),
//                                 controller: _bagdeNameController,
//                               ),
//                               TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText: "User Id",
//                                   border: InputBorder.none,
//                                 ),
//                                 controller: _bagdePersonController,
//                               ),
//                               TextButton(
//                                 onPressed: _handleGiveBadgePoints,
//                                 child: Text("Submit"),
//                               ),
//                             ],
//                           ),
//                         ),

//                   // ElevatedButton(
//                   //   onPressed: _handleSaveButtonPushed,
//                   //   child: Text("Save"),
//                   // ),

//                   // ElevatedButton(
//                   //   onPressed: () async {
//                   //     await downloadCSV();
//                   //   },
//                   //   child: Text("Download CSV"),
//                   // )
//                 ],
//               ),
//             ),
//     );
//   }

//   _buildTransferPoint() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           TextFormField(
//             decoration: InputDecoration(
//               hintText: "付与するポイント",
//               border: InputBorder.none,
//             ),
//             keyboardType: TextInputType.number,
//             controller: _transferPointsController,
//           ),
//           TextFormField(
//             decoration: InputDecoration(
//               hintText: "ポイントを渡すユーザーのID",
//               border: InputBorder.none,
//               suffix: InkWell(
//                 onTap: _handleMenuTap,
//                 child: Icon(
//                   Icons.menu,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             controller: _transferPersonController,
//           ),
//           TextButton(
//             onPressed: _handleTransferPoints,
//             child: Text("ポイントをあげる"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TimeDisplay extends StatefulWidget {
//   Function onClick;
//   TimeOfDay time;
//   TimeDisplay({this.onClick, this.time});
//   @override
//   _TimeDisplayState createState() => _TimeDisplayState();
// }

// class _TimeDisplayState extends State<TimeDisplay> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () async {
//         TimeOfDay selected = await showTimePicker(
//           context: context,
//           initialTime: widget.time,
//           //???ここに、渡す事もできるよね。time1としてセットした変数を
//         );
//         if (selected != null) widget.onClick(selected);
//       },
//       child: Text(
//         widget.time.format(context),
//         style: TextStyle(fontSize: 10),
//       ),
//     );
//   }
// }

// Widget bar(String title) {
//   return Container(
//     child: Center(
//         child: Text(
//       title, //共通化して、関数を利用した
//       style: TextStyle(color: Colors.white),
//     )),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       color: Colors.grey,
//     ),
//     constraints: BoxConstraints.expand(height: 50),
//   );
// }
