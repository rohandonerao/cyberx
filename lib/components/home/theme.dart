
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ThemeSwitchDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Switch Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Light Theme'),
            onTap: () {
              AdaptiveTheme.of(context).setLight();
              Navigator.pop(context); 
            },
          ),
          ListTile(
            title: Text('Dark Theme'),
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
