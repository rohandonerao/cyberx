// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_createimmutables, unused_import, prefer_const_literals_to_create_immutables

import 'package:cyberx/components/home/assistant/assistant.dart';
import 'package:cyberx/components/home/home.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          PageView(children: [
            MyHomePage(),
            ChatGPTScreen(),
          ]),
        ],
      ),
    ));
  }
}
