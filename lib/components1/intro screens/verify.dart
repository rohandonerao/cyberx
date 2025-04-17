// ignore_for_file: unused_import, camel_case_types, use_build_context_synchronously, prefer_const_constructors, use_super_parameters, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:cyberx/components1/intro%20screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class verify extends StatefulWidget {
  final String verificationId;
  const verify({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<verify> createState() => _verifyState();
}

class _verifyState extends State<verify> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  void verifyOtp() async {
    try {
      String smsCode = '';
      for (TextEditingController controller in otpControllers) {
        smsCode += controller.text;
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyRegister()),
      );
    } catch (ex) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $ex'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  // For mobile layout
                  return buildMobileLayout();
                } else {
                  // For desktop layout
                  return buildDesktopLayout();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMobileLayout() {
    return Column(
      children: [
        SizedBox(height: 18),
        buildIllustration(),
        SizedBox(height: 24),
        buildHeaderText(),
        SizedBox(height: 10),
        buildSubHeaderText(),
        SizedBox(height: 38),
        buildOtpInput(),
        SizedBox(height: 18),
        buildResendCodeText(),
      ],
    );
  }

  Widget buildDesktopLayout() {
    return Center(
      child: Container(
        width: 800,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side: Illustration and Header
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildIllustration(),
                SizedBox(height: 24),
                buildHeaderText(),
              ],
            ),
            SizedBox(width: 50),
            // Right side: Subheader, OTP Input, and Resend Code
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  buildSubHeaderText(),
                  SizedBox(height: 38),
                  buildOtpInput(),
                  SizedBox(height: 18),
                  buildResendCodeText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIllustration() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        'assets/images/illustration-3.png',
      ),
    );
  }

  Widget buildHeaderText() {
    return Text(
      'Verification',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildSubHeaderText() {
    return Text(
      "Enter your OTP code number",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildOtpInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            buildOtpRow(),
            SizedBox(height: 22),
            buildVerifyButton(),
          ],
        ),
      ),
    );
  }

  Widget buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) =>
            _textFieldOTP(first: index == 0, last: index == 5, index: index),
      ),
    );
  }

  Widget _textFieldOTP(
      {required bool first, required bool last, required int index}) {
    return Container(
      width: 40,
      height: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: otpControllers[index],
          autofocus: first,
          onChanged: (value) {
            if (value.length == 1 && !last) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && !first) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.purple),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          verifyOtp();
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Text(
            'Verify',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildResendCodeText() {
    return Column(
      children: [
        Text(
          "Didn't you receive any code?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
        Text(
          "Resend New Code",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
