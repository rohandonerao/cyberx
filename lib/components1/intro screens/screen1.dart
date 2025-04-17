// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 50,),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 20,
                  // color: Colors.black87,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset('assets/images/SafeNet.jpg'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'SafeNet',
                          style: TextStyle(
                              // color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Best Camera Services",
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
                // color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
