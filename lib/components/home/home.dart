// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unused_element, use_build_context_synchronously

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cyberx/CyberX%20ChatBot/HomePage.dart';
import 'package:cyberx/components/home/bottomnavigation.dart';
import 'package:cyberx/components/home/chatscreen.dart';
import 'package:cyberx/components1/intro%20screens/loginscreen.dart';
// import 'package:cyberx/components/home/profile.dart';
import 'package:cyberx/components1/intro%20screens/splash.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? lastScanTime;
  late Timer _timer;
  String? updatedProfilePic;
  @override
  void initState() {
    super.initState();
    lastScanTime = DateTime.now();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {});
    });
  }

  String _formatLastScanTime() {
    if (lastScanTime == null) return '';

    Duration difference = DateTime.now().difference(lastScanTime!);
    if (difference.inDays > 1) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays == 1) {
      return "1 day ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} hours ago";
    } else {
      return "${difference.inMinutes} minutes ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Appbar
        appBar: MediaQuery.of(context).size.width < 850
            ? AppBar(
                title: const Text(
                  'Cyber X',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    letterSpacing: 1,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_active,
                      size: 25,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            : null,
        drawer: Drawer(
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
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
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
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
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
                      MaterialPageRoute(
                        builder: (context) => login(),
                      ));
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return buildMobileLayout();
              } else if (constraints.maxWidth < 850) {
                return buildTabletLayout();
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
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: const Text(
                  "Welcome back dear!",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Your Apps are secured",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 94, 178, 229),
                        Color.fromARGB(255, 187, 203, 206),
                        Color.fromARGB(255, 228, 226, 223),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, size: 28, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildScoreCard(score: '65/100', label: 'Security'),
                ),
              ),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildScoreCard(score: '80/100', label: 'Privacy'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    lastScanTime = DateTime.now();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.deepPurple,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                ),
                child: const Text(
                  "Quick Scan",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  currentUserId: '',
                                  friendId: '',
                                  friendName: '',
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 55, vertical: 9),
                  ),
                  child: Text("CharBot")),
            ),
          ]),
          const SizedBox(height: 20),
          Text(
            "Last Scan: ${_formatLastScanTime()}",
            style: const TextStyle(
              fontSize: 15,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CarouselSlider(
              items: [
                _buildCards(),
                _buildCards1(),
                _buildCards2(),
              ],
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCards() {
    return SingleChildScrollView(
      child: Container(
        child: SizedBox(
          child: Card(
            elevation: 08,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  leading: Container(
                    width: 80,
                    // height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/CyberVigil.jpg'),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 94, 178, 229),
                          Color.fromARGB(255, 187, 203, 206),
                          Color.fromARGB(255, 228, 226, 223),
                        ],
                      ),
                    ),
                  ),
                  title: Text(
                    'CyberVigil ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Text(
                        "Try Now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 08,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCards1() {
    return SingleChildScrollView(
      child: Container(
        child: SizedBox(
          child: Card(
            elevation: 08,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  leading: Container(
                    width: 80,
                    // height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 94, 178, 229),
                          Color.fromARGB(255, 187, 203, 206),
                          Color.fromARGB(255, 228, 226, 223),
                        ],
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/TrustyTalk.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'This is a sample card with some text inside.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Text(
                        "Try Now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 08,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCards2() {
    return SingleChildScrollView(
      child: Container(
        child: SizedBox(
          child: Card(
            elevation: 08,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.orange, width: 2),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  leading: Container(
                    width: 80,
                    // height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 94, 178, 229),
                          Color.fromARGB(255, 187, 203, 206),
                          Color.fromARGB(255, 228, 226, 223),
                        ],
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/SafeNet.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    'This is a sample card with some text inside.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Text(
                        "Try Now",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 08,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard({required String score, required String label}) {
    double numericScore = double.parse(score.split('/')[0]);
    double percentage = (numericScore / 100).clamp(0, 1);

    Color fillColor;
    if (numericScore >= 80 && numericScore <= 100) {
      fillColor = Colors.blue[700]!;
    } else if (numericScore >= 50 && numericScore < 80) {
      fillColor = Colors.orange;
    } else {
      fillColor = Colors.red;
    }

    return Container(
      width: 150,
      height: 150,
      child: SizedBox(
        height: 200,
        width: 200,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide.none,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: fillColor, width: 0),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    score,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: fillColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Image.asset('assets/images/d2.jpg'),
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    leading: const Icon(Icons.account_circle_sharp),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
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
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: buildMobileLayout(),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to Cyber X!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First Section: Content of the Drawer
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Image.asset('assets/images/d2.jpg'),
                ),
                ListTile(
                  title: const Text('Profile'),
                  leading: const Icon(Icons.account_circle_sharp),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
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
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Add spacing between sections
          // Second Section: Mobile Screen Layout without AppBar
          buildMobileLayout(),
          SizedBox(height: 20), // Add spacing between sections
          // Third Section: Card with Hello Message
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome to Cyber X!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeSwitchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Switch Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Light Theme'),
            onTap: () {
              AdaptiveTheme.of(context).setLight();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Dark Theme'),
            onTap: () {
              AdaptiveTheme.of(context).setDark();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
