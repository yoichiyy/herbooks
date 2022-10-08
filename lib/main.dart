import 'package:counter/ui/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //多分hive使っていた時のファイル保管場所呼び出し
  // final directory = await getApplicationDocumentsDirectory();
  runApp(const MyApp());
}
