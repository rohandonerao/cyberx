// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cyberx/components/loginButton.dart';
import 'package:cyberx/components/textfield.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200,),
            MyTextField(hintText: 'gmail', obscureText: false,),
            SizedBox(height: 20,),
            MyTextField(hintText: 'password', obscureText: true,),
            SizedBox(height: 20,),
            MyLoginButton(),
          ],
        ),
      ),
    );
  }
}