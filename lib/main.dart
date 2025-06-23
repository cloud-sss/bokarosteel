import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/socketConnectModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/splashScreen.dart';

void main() async {
  // await Future.delayed(const Duration(seconds: 3));
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefModel.init();
  ConnectSocket.initConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SynergicMobile',
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      home: const SplashScreen(),
      builder: FlutterSmartDialog.init(),
      navigatorObservers: [FlutterSmartDialog.observer],
    );
  }
}
