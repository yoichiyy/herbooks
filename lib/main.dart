import 'package:counter/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //多分hive使っていた時のファイル保管場所呼び出し
  // final directory = await getApplicationDocumentsDirectory();
  runApp(const MyApp());
}

  // get() async {
  //   prefs = await SharedPreferences.getInstance();

  //   // //元々あったコードだが、多分削除してOK。間違えている可能性あり。
  //   // NotificationPlugin notificationPlugin;
  //   // await notificationPlugin.showNotification();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
