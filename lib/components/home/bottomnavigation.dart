// ignore_for_file: prefer_const_constructors, prefer_final_fields

// import 'package:cyberx/Add_Contact.dart';
import 'package:cyberx/Add_Contact.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/emergency.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/india.dart';
// import 'package:cyberx/CyberX%20ChatBot/emergency/newscard.dart';
// // import 'package:cyberx/components/home/chatscreen.dart';
// // import 'package:cyberx/components/home/mainhome.dart';
// import 'package:cyberx/components1/accounts/spam.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Widget> _screens = [
    Emergency(),
    AddContactsPage(),
    IndiaNews(),
  ];

  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          // Position the DotNavigationBar at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                height: 170, // Adjusted height to prevent overflow
                child: DotNavigationBar(
                  borderRadius: 30,
                  enableFloatingNavBar: true,
                  dotIndicatorColor: Colors.black,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.blue,
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    DotNavigationBarItem(
                      icon: Icon(Icons.home),
                      selectedColor: Colors.black,
                    ),
                    DotNavigationBarItem(
                      icon: Icon(Icons.emergency_share),
                      selectedColor: Colors.black,
                    ),
                    DotNavigationBarItem(
                      icon: Icon(Icons.person),
                      selectedColor: Colors.black,
                    ),
                    // DotNavigationBarItem(
                    //   icon: Icon(Icons.settings),
                    //   selectedColor: Colors.black,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
