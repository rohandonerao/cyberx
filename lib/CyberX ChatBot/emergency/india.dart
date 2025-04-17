// ignore_for_file: unused_import

import 'package:cyberx/CyberX%20ChatBot/emergency/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class IndiaNews extends StatefulWidget {
  @override
  _IndiaNewsState createState() => _IndiaNewsState();
}

class _IndiaNewsState extends State<IndiaNews> {
  List<dynamic> _news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final String apiKey = 'eea6685a507645438141ec1c862c6841';
    final String url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _news = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  void _showNewsDetail(
      String title, String description, String url, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(
          title: title,
          description: description,
          url: url,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indian News'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  String title = _news[index]['title'] ?? 'Title not available';
                  String description = _news[index]['description'] ??
                      'Description not available';
                  String url = _news[index]['url'] ?? '';
                  String imageUrl = _news[index]['urlToImage'] ?? '';
                  _showNewsDetail(title, description, url, imageUrl);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _news[index]['urlToImage'] != null &&
                            _news[index]['urlToImage'].isNotEmpty
                        ? Image.network(
                            _news[index]['urlToImage'],
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 100,
                            color: Colors.grey,
                            child: Icon(Icons.image),
                          ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        _news[index]['title'] ?? 'Title not available',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
