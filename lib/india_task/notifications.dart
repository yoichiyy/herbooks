// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io' show File, Platform;

// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// import 'package:rxdart/subjects.dart';

// class NotificationPlugin {
//   //
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   final BehaviorSubject<ReceivedNotification>
//       didReceivedLocalNotificationSubject =
//       BehaviorSubject<ReceivedNotification>();
//   var initializationSettings;
//   var timezone;
//   NotificationPlugin._() {
//     init();
//   }

//   init() async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     if (Platform.isIOS) {
//       _requestIOSPermission();
//     }
//     initializePlatformSpecifics();

//     tz.initializeTimeZones();
//     timezone = await FlutterNativeTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timezone));
//   }

//   initializePlatformSpecifics() {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('app_notf_icon');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {
//         ReceivedNotification receivedNotification = ReceivedNotification(
//           id: id,
//           title: title,
//           body: body,
//           payload: payload,
//         );
//         didReceivedLocalNotificationSubject.add(receivedNotification);
//       },
//     );
//     initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//   }

//   _requestIOSPermission() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         .requestPermissions(
//           alert: false,
//           badge: true,
//           sound: true,
//         );
//   }

//   setListenerForLowerVersions(Function onNotificationInLowerVersions) {
//     didReceivedLocalNotificationSubject.listen((receivedNotification) {
//       onNotificationInLowerVersions(receivedNotification);
//     });
//   }

//   // setOnNotificationClick(Function onNotificationClick) async {
//   //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//   //     //onDidReceiveNotificationResponseに置き換える必要あり。

//   //     //   onSelectNotification: (String payload) async {
//   //     // onNotificationClick(payload);
//   //   });
//   // }

// //基本。とりあえず通知ならすだけ
//   // Future<void> showNotification() async {
//   //   var androidChannelSpecifics = AndroidNotificationDetails(
//   //     'CHANNEL_ID',
//   //     'CHANNEL_NAME',
//   //     channelDescription: "CHANNEL_DESCRIPTION",
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //     playSound: true,
//   //     timeoutAfter: 5000,
//   //     styleInformation: DefaultStyleInformation(true, true),
//   //   );
//   //   var iosChannelSpecifics = DarwinNotificationDetails(
//   //     threadIdentifier: 'thread_id',
//   //   );
//   //   var platformChannelSpecifics = NotificationDetails(
//   //       android: androidChannelSpecifics, iOS: iosChannelSpecifics);

//   //   await flutterLocalNotificationsPlugin.show(
//   //     0,
//   //     'Hey! You have some over due tasks',
//   //     'Please complete them', //null
//   //     platformChannelSpecifics,
//   //     payload: 'New Payload',
//   //   );
//   // }

//   Future<void> cancelRepeatNotification(id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }

// //メインの機能だろう。
//   Future<void> scheduleNotification(
//       String taskName, DateTime scheduleNotificationDateTime) async {
//     var androidChannelSpecifics = AndroidNotificationDetails(
//       'CHANNEL_ID 4',
//       'CHANNEL_NAME 4',
//       channelDescription: "CHANNEL_DESCRIPTION 4",
//       icon: 'secondary_icon',
//       sound: RawResourceAndroidNotificationSound('my_sound'),
//       largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
//       enableLights: true,
//       color: const Color.fromARGB(255, 255, 0, 0),
//       ledColor: const Color.fromARGB(255, 255, 0, 0),
//       ledOnMs: 1000,
//       ledOffMs: 500,
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       timeoutAfter: 5000,
//       styleInformation: DefaultStyleInformation(true, true),
//     );
//     var iosChannelSpecifics = DarwinNotificationDetails(
//       sound: 'my_sound.aiff',
//     );
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidChannelSpecifics,
//       iOS: iosChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'You have an overdue task',
//       taskName,
//       tz.TZDateTime.from(
//           scheduleNotificationDateTime, tz.getLocation(timezone)),
//       platformChannelSpecifics,
//       payload: 'Test Payload',
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

// //snooze
//   Future<void> repeatNotification(String title, String body, int id) async {
//     var androidChannelSpecifics = AndroidNotificationDetails(
//       title,
//       'CHANNEL_NAME 3',
//       channelDescription: "CHANNEL_DESCRIPTION 3",
//       importance: Importance.max,
//       priority: Priority.high,
//       styleInformation: DefaultStyleInformation(true, true),
//     );
//     var iosChannelSpecifics = DarwinNotificationDetails(
//       threadIdentifier: 'thread_id',
//     );
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidChannelSpecifics, iOS: iosChannelSpecifics);
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       id,
//       title,
//       body,
//       RepeatInterval.everyMinute,
//       platformChannelSpecifics,
//       payload: 'Test Payload',
//       androidAllowWhileIdle: true,
//     );
//   }

//   scheduleRepeatNotification(
//       String bodyTaskName, DateTime scheduleNotificationDateTime) async {
//     var androidChannelSpecifics = AndroidNotificationDetails(
//       "アンドロイド通知",
//       'CHANNEL_NAME 4',
//       channelDescription: "CHANNEL_DESCRIPTION 4",
//       icon: 'secondary_icon',
//       sound: RawResourceAndroidNotificationSound('my_sound'),
//       largeIcon: DrawableResourceAndroidBitmap('large_notf_icon'),
//       enableLights: true,
//       color: const Color.fromARGB(255, 255, 0, 0),
//       ledColor: const Color.fromARGB(255, 255, 0, 0),
//       ledOnMs: 1000,
//       ledOffMs: 500,
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       timeoutAfter: 5000,
//       styleInformation: DefaultStyleInformation(true, true),
//     );
//     var iosChannelSpecifics = DarwinNotificationDetails(
//       sound: 'my_sound.aiff',
//       threadIdentifier: 'thread_id',
//     );
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidChannelSpecifics,
//       iOS: iosChannelSpecifics,
//     );
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'スケジュール通知',
//       bodyTaskName,
//       tz.TZDateTime.from(
//           scheduleNotificationDateTime, tz.getLocation(timezone)),
//       platformChannelSpecifics,
//       payload: 'Test Payload',
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );

//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       0,
//       "スヌーズ通知",
//       bodyTaskName,
//       RepeatInterval.everyMinute,
//       platformChannelSpecifics,
//       payload: 'Test Payload',
//       androidAllowWhileIdle: true,
//     );
//   }

// //どこにも使われていない
//   // Future<void> showNotificationWithAttachment() async {
//   //   var attachmentPicturePath = await _downloadAndSaveFile(
//   //       'https://via.placeholder.com/800x200', 'attachment_img.jpg');
//   //   var iOSPlatformSpecifics = DarwinNotificationDetails(
//   //     attachments: [DarwinNotificationAttachment(attachmentPicturePath)],
//   //   );
//   //   var bigPictureStyleInformation = BigPictureStyleInformation(
//   //     FilePathAndroidBitmap(attachmentPicturePath),
//   //     contentTitle: '<b>Attached Image</b>',
//   //     htmlFormatContentTitle: true,
//   //     summaryText: 'Test Image',
//   //     htmlFormatSummaryText: true,
//   //   );
//   //   var androidChannelSpecifics = AndroidNotificationDetails(
//   //     'CHANNEL ID 2',
//   //     'CHANNEL NAME 2',
//   //     channelDescription: 'CHANNEL DESCRIPTION 2',
//   //     importance: Importance.high,
//   //     priority: Priority.high,
//   //     styleInformation: bigPictureStyleInformation,
//   //   );
//   //   var notificationDetails = NotificationDetails(
//   //       android: androidChannelSpecifics, iOS: iOSPlatformSpecifics);
//   //   await flutterLocalNotificationsPlugin.show(
//   //     0,
//   //     'Title with attachment',
//   //     'Body with Attachment',
//   //     notificationDetails,
//   //   );
//   // }

//   // _downloadAndSaveFile(String url, String fileName) async {
//   //   var directory = await getApplicationDocumentsDirectory();
//   //   var filePath = '${directory.path}/$fileName';
//   // var response = await http.get(url);
//   // var file = File(filePath);
//   // await file.writeAsBytes(response.bodyBytes);
//   // return filePath;
//   // }

// //どこにも使われていない
//   // Future<int> getPendingNotificationCount() async {
//   //   List<PendingNotificationRequest> p =
//   //       await flutterLocalNotificationsPlugin.pendingNotificationRequests();
//   //   return p.length;
//   // }

//   // Future<void> cancelNotification() async {
//   //   await flutterLocalNotificationsPlugin.cancel(0);
//   // }

//   Future<void> cancelAllNotification() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
// }

// NotificationPlugin notificationPlugin = NotificationPlugin._();

// class ReceivedNotification {
//   final int id;
//   final String title;
//   final String body;
//   final String payload;
//   ReceivedNotification({
//     @required this.id,
//     @required this.title,
//     @required this.body,
//     @required this.payload,
//   });
// }
