// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:cyberx/CyberX%20ChatBot/emergency/AmbulanceEmergency.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/ArmyEmergency.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/FirebrigadeEmergency.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/newscard.dart';
import 'package:cyberx/CyberX%20ChatBot/emergency/policeemergency.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/BusStationCard.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/ChatbotCard.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/HospitalCard.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/PGNEARME.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/PharmacyCard.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/PoliceStationCard.dart';
import 'package:cyberx/CyberX%20ChatBot/safeHOme/Trusted.dart';
import 'package:cyberx/components/home/Mainoage.dart';
import 'package:cyberx/components/home/SafeHome.dart';
// import 'package:cyberx/components/home/bottomnavigation.dart';
import 'package:cyberx/components/home/home.dart';
// import 'package:cyberx/components/home/profile.dart';
import 'package:cyberx/components1/intro%20screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  String? updatedProfilePic;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _updateProfilePic(String newProfilePic) {
    setState(() {
      updatedProfilePic = newProfilePic;
    });
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  static Future<void> openMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';

    if (Platform.isAndroid) {
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        throw 'Could not launch $googleUrl';
      }
    }
    final Uri _url = Uri.parse(googleUrl);
    try {
      await launch(_url.toString());
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'something went wrong! call emergency number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cyber-X',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: updatedProfilePic != null
                  ? CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      radius: 40,
                      backgroundImage: NetworkImage(updatedProfilePic!),
                    )
                  : Image.asset('assets/logo/d2.jpg'),
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.account_circle_sharp),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rohan()),
                );
              },
            ),
            ListTile(
              title: const Text('Switch Theme'),
              leading: const Icon(Icons.brightness_6),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ThemeSwitchDialog();
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Privacy & Settings'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Rohan()),
                );
              },
            ),
            ListTile(
              title: Text('LogOut'),
              leading: Icon(Icons.logout),
              onTap: () async {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setBool(SplashScreenState.KEYLOGIN, false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        "EMERGENCY                                                      ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            PoliceEmergency(),
                            AmbulanceEmergency(),
                            FirebrigadeEmergency(),
                            ArmyEmergency(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text(
                              "FIND A ROUTE                                                    ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: const [
                                  PoliceStationCard(onMapFunction: openMap),
                                  HospitalCard(onMapFunction: openMap),
                                  PharmacyCard(onMapFunction: openMap),
                                  BusStationCard(onMapFunction: openMap),
                                  pdfind(onMapFunction: openMap),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              "LOCATION SECTION                                           ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 500,
                            height: 250,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [SafeHome(), Trusted()],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Text(
                              "SUGGESTION SECTION                                      ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Container(
                            width: 500,
                            height: 200,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [ChatBot()],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          children: [
                            Text(
                              "NEWS SECTION                                                   ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Container(
                              width: 500,
                              height: 200,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [NewsCard()],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  login() {}
}
