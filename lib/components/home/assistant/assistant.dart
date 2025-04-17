// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGPTScreen extends StatefulWidget {
  @override
  _ChatGPTScreenState createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _onSendMessage() async {
    if (_textEditingController.text.isEmpty) return;

    Message message = Message(text: _textEditingController.text, isMe: true);
    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });

    String? response = await _sendMessageToChatGpt(message.text);

    if (response != null) {
      Message chatGpt = Message(text: response, isMe: false);
      setState(() {
        _messages.insert(0, chatGpt);
      });
    } else {
      print("Failed to get response from ChatGPT API");
    }
  }

  Future<String?> _sendMessageToChatGpt(String message) async {
    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ],
      "max_tokens": 500,
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer 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",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> parsedResponse = json.decode(response.body);
        String? reply = parsedResponse['choices'][0]['message']['content'];
        return reply;
      } else {
        log("API request failed with status code: ${response.statusCode}");
        log("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Error while sending message to ChatGPT API: $e");
      return null;
    }
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            //  color: message.isMe ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              // color: message.isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CyberX-ChatBot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            //color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 192, 225, 252),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          hintText: 'Message to CyberX...',
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _onSendMessage,
                  child: CircleAvatar(
                    //backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      //  color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
