import 'package:flutter/material.dart';
import 'profile.dart'; // Assuming your ProfilePage is in profile.dart

class Rohan extends StatefulWidget {
  @override
  _RohanState createState() => _RohanState();
}

class _RohanState extends State<Rohan> {
  String? _profilePicUrl;

  void _updateProfilePic(String imageUrl) {
    setState(() {
      _profilePicUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Column(
        children: [
          // Display profile picture from ProfilePage
          _profilePicUrl != null
              ? Image.network(_profilePicUrl!)
              : Placeholder(),
          // Navigate to ProfilePage
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    onProfilePicUpdated: _updateProfilePic,
                  ),
                ),
              );
            },
            child: Text('Go to Profile Page'),
          ),
          // Other widgets in MainPage
        ],
      ),
    );
  }
}
