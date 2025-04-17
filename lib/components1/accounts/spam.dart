import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NumberDetectionPage extends StatefulWidget {
  @override
  _NumberDetectionPageState createState() => _NumberDetectionPageState();
}

class _NumberDetectionPageState extends State<NumberDetectionPage> {
  String phoneNumber = '';
  String result = '';
  bool isLoading = false;

  Future<void> detectNumber(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });

    final String apiKey = 'lw2fdleb-pdzy3glt3a02yc2xf3qrbjcxjx-jq2tl78';
    final String baseUrl = 'https://api4.truecaller.com/v1/lookup';

    final Uri uri = Uri.parse('$baseUrl/$phoneNumber');

    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $apiKey',
      });

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        // Extract the name from the decoded response
        final String name = decodedResponse['data']['name'];
        setState(() {
          // Set the result to display the name
          result = 'Name: $name';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          result = 'Error: Phone number not found';
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Detection'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (phoneNumber.isNotEmpty) {
                    detectNumber(phoneNumber);
                  } else {
                    setState(() {
                      result = 'Please enter a phone number';
                    });
                  }
                },
                child: Text('Detect'),
              ),
              SizedBox(height: 20),
              isLoading ? CircularProgressIndicator() : Text(result),
            ],
          ),
        ),
      ),
    );
  }
}
