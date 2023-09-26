import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';

class LinkShare extends StatefulWidget {
  const LinkShare({super.key});

  @override
  State<LinkShare> createState() => _LinkShareState();
}

class _LinkShareState extends State<LinkShare> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
            child: Text("Link Share", style: appbarTextStyle),
          )),
      body: Center(
        child: Text('Link Share Content'),
      ),
    );
  }
}
