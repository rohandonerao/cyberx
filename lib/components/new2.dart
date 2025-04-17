import 'package:flutter/material.dart';

class CustomMessageTextField extends StatelessWidget {
  final String currentId;
  final String friendId;

  const CustomMessageTextField({
    required this.currentId,
    required this.friendId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // Your custom message text field implementation goes here
        // You can use TextField or any other widget you prefer for message input
        );
  }
}
