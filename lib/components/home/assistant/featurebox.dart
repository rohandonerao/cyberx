// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, avoid_unnecessary_containers

import 'package:cyberx/pallet.dart';
import 'package:flutter/material.dart';

class Featurebox extends StatelessWidget {
  // final Color color;
  final String headerText;
  final String description;
  const Featurebox(
      {super.key, required this.headerText, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
          // color: color,
          borderRadius: BorderRadius.all(
        Radius.circular(15),
      )),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                description,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
