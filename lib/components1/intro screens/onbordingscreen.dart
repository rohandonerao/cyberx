// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, avoid_unnecessary_containers, unused_import
import 'package:cyberx/components/home/assistant/assistant.dart';
import 'package:cyberx/components/home/bottomnavigation.dart';
import 'package:cyberx/components1/intro%20screens/loginscreen.dart';
import 'package:cyberx/components1/intro%20screens/screen1.dart';
import 'package:cyberx/components1/intro%20screens/screen2.dart';
import 'package:cyberx/components1/intro%20screens/screen3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  PageController _controller = PageController();
  bool lastpage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                lastpage = (index == 2);
              });
            },
            children: [
              Screen1(),
              screen2(),
              screen3(),
            ]),
        Container(
          alignment: Alignment(0, .8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // skip
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => login()));
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        // color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1),
                  )),
              // smooth indicator
              SmoothPageIndicator(controller: _controller, count: 3),
              // next or done
              lastpage
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            // color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ))
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                            // color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      )),
              // // done
              // Text("Done"),
            ],
          ),
        )
      ]),
    );
  }
}
