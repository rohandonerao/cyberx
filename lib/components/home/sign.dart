// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Positive Affirmation Messenger'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Message>>(
        stream:
            _messageService.getMessages(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Message>? messages = snapshot.data;
            if (messages != null && messages.isNotEmpty) {
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index].message),
                    subtitle: Text('From: ${messages[index].senderId}'),
                  );
                },
              );
            } else {
              return Center(child: Text('No messages'));
            }
          }
        },
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  void signOut() async {
    await _auth.signOut();
  }
}

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String userId) {
    return _firestore
        .collection('messages')
        .where('recipientId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage(String message, String recipientId) async {
    try {
      String senderId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('messages').add({
        'message': message,
        'recipientId': recipientId,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print(error.toString());
    }
  }
}

class Message {
  final String id;
  final String message;
  final String senderId;
  final String recipientId;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.message,
    required this.senderId,
    required this.recipientId,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      message: data['message'] ?? '',
      senderId: data['senderId'] ?? '',
      recipientId: data['recipientId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
