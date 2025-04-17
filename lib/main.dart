// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

// import 'package:assistant/otp.dart';
import 'dart:io';
import 'package:cyberx/components1/intro%20screens/splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:assistant/welcome.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDoBdo_eh1Y_De_ws78FxLZZ4X92dHwt8o",
              appId: "1:230018352054:android:2eb328dfc6e85e6a57f717",
              messagingSenderId: "230018352054",
              projectId: "cyberx-2410"),
        )
      : await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.black,
          fill: 0,
          weight: 100,
          opticalSize: 48,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        iconTheme: const IconThemeData(
            color: Colors.black, fill: 0, weight: 100, opticalSize: 48),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
