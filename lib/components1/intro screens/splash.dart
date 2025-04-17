// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:cyberx/components/home/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:cyberx/components1/intro%20screens/onbordingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  static const String KEYLOGIN = 'login';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    whereToGo(context); // Pass context to whereToGo function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: ClipOval(
            child: CircleAvatar(
              radius: 50, // Adjust the radius as needed
              child: Image.asset(
                'assets/logo/logo.jpg',
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void whereToGo(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    var isloggedin = sharedPreferences.getBool(KEYLOGIN);

    Timer(
      Duration(seconds: 3),
      () {
        if (isloggedin != null) {
          if (isloggedin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => onBoardingScreen()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => onBoardingScreen()),
          );
        }
      },
    );
  }
}
