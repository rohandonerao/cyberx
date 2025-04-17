import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final String date;
  final bool isMe;
  final String friendName;
  final String myName;
  final String type;

  const SingleMessage({
    Key? key,
    required this.message,
    required this.date,
    required this.isMe,
    required this.friendName,
    required this.myName,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            isMe ? myName : friendName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Material(
            borderRadius: BorderRadius.circular(10),
            color: isMe ? Colors.blue : Colors.grey[300],
            elevation: 3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Text(
            date,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
