// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class MyLoginButton extends StatelessWidget {
  const MyLoginButton({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(9)
      ),
      child: Center(
        child: Text("log in",style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),),
      ),
    );
  }
}