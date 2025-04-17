// ignore_for_file: unused_local_variable, prefer_const_constructors, sort_child_properties_last, unused_import, use_build_context_synchronously, prefer_collection_literals, camel_case_types, avoid_unnecessary_containers

import 'dart:developer';
import 'package:cyberx/components/home/bottomnavigation.dart';
import 'package:cyberx/components/home/home.dart';
import 'package:cyberx/components1/accounts/mobile.dart';
import 'package:cyberx/components1/intro%20screens/forgot.dart';
import 'package:cyberx/components1/intro%20screens/number.dart';
import 'package:cyberx/components1/intro%20screens/register.dart';
import 'package:cyberx/components1/intro%20screens/splash.dart';
import 'package:cyberx/components1/intro%20screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _MyLoginState();
}

class _MyLoginState extends State<login> {
  bool _isPasswordVisible = false;
  String emai = '';
  String pass = '';
  TextEditingController mailController = TextEditingController();
  TextEditingController passw = TextEditingController();

  void loginAccount() async {
    String emai = mailController.text.trim();
    String pas = passw.text.trim();

    if (emai == "" || pas == "") {
      // Show an error dialog if email or password is empty
      showAlertDialog("Error", "Please enter your details.");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: emai, password: pas);

        if (userCredential.user != null) {
          // Navigate to home screen
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => Home()));

          // Set login status in shared preferences
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool(SplashScreenState.KEYLOGIN, true);
        }
      } on FirebaseAuthException catch (ex) {
        // Show an error dialog with the exception message
        showAlertDialog("Error", ex.message ?? "An error occurred.");
      }
    }
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfff7f6fb),
      body: SingleChildScrollView(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 850) {
                return buildMobileLayout();
              } else {
                return buildDesktopLayout();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 18),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  //  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/illustration-3.png', // Change the image path
                ),
              ),
              SizedBox(height: 24),
              SizedBox(height: 28),
              buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktopLayout() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '                                   Welcome Back!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              //yycolor: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Illustration
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    //  color: Colors.deepPurple.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/illustration-3.png',
                  ),
                ),
              ),
              SizedBox(width: 50),
              // Right side: Form
              Center(child: buildForm()),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    return Container(
      width: 400, // Adjust the width as needed
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Enter your credentials to log in",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              // color: Colors.black38,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: mailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              //  enabledBorder: OutlineInputBorder(
              //    borderSide: BorderSide(color: Colors.black12),
              ////    borderRadius: BorderRadius.circular(10),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black12),
              //   borderRadius: BorderRadius.circular(10),
              // ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: passw,
            obscureText: !_isPasswordVisible,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black12),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black12),
              //   borderRadius: BorderRadius.circular(10),
              // ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  // color: Colors.black38,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      "  SignUp",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ))),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                    "                                    Forgot password",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
          SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                loginAccount();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('Login', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
