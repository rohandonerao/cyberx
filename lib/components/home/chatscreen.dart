import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberx/components/home/assistant/single_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'message_text_field.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;

  const ChatScreen({
    Key? key,
    required this.currentUserId,
    required this.friendId,
    required this.friendName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String myName;
  late CollectionReference chatMessages;

  @override
  void initState() {
    super.initState();
    getMyName();
    chatMessages = FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId(widget.currentUserId, widget.friendId))
        .collection('messages');
  }

  void getMyName() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .get();
    setState(() {
      myName = userSnapshot['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(widget.friendName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatMessages
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView(
                      reverse: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        final isMe =
                            document['senderId'] == widget.currentUserId;
                        return SingleMessage(
                          message: document['message'],
                          date: document['timestamp'].toString(),
                          isMe: isMe,
                          friendName: widget.friendName,
                          myName: myName,
                          type: document['type'],
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
          MessageTextField(
            currentId: widget.currentUserId,
            friendId: widget.friendId,
            onSendMessage: sendMessage,
          ),
        ],
      ),
    );
  }

  void sendMessage(String message) async {
    try {
      await chatMessages.add({
        'senderId': widget.currentUserId,
        'message': message,
        'timestamp': Timestamp.now(),
        'type': 'text', // You can adjust this based on your message type
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send message. Please try again.');
    }
  }

  String getChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }
}
