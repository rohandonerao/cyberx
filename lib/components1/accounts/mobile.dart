// ignore_for_file: unused_import, prefer_const_constructors, use_super_parameters, use_build_context_synchronously

import 'package:cyberx/components1/intro%20screens/loginscreen.dart';
import 'package:cyberx/components1/intro%20screens/register.dart';
import 'package:cyberx/components1/intro%20screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  TextEditingController mobile = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void createAccount() async {
    String phone = "+91${mobile.text.trim()}";
    if (mobile.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter your phone number.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _firebaseAuth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException ex) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Verification Failed'),
                content: Text(ex.message ?? 'Unknown error occurred.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => verify(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {},
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => login()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
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
    return Column(
      children: [
        SizedBox(height: 18),
        buildIllustration(),
        SizedBox(height: 24),
        buildText(),
        SizedBox(height: 28),
        buildForm(),
      ],
    );
  }

  Widget buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildIllustration(),
        SizedBox(width: 50),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildText(),
            SizedBox(height: 28),
            buildDesktopForm(),
          ],
        ),
      ],
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
        'assets/images/illustration-2.png',
      ),
    );
  }

  Widget buildText() {
    return Text(
      "Add your phone number. We'll send you a verification code so we know you're real",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: mobile,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: Icon(
                mobile.text.length == 10 ? Icons.check_circle : null,
                color: Colors.green,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                createAccount();
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
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDesktopForm() {
    return Container(
      width: 400,
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: mobile,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              setState(() {});
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              suffixIcon: Icon(
                mobile.text.length == 10 ? Icons.check_circle : null,
                color: Colors.green,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                createAccount();
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
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
