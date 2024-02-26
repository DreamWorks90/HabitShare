import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

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
      body: ShareContentScreen(),
    );
  }
}

class ShareContentScreen extends StatelessWidget {
  void shareContent() async {
    try {
      await FlutterShare.share(
        title: 'Invitation to Habit Share',
        text: "Hey, I'd like you to join Habit Share app! Download it from [app store link]",
        linkUrl: 'https://example.com',// Replace with HabitShare app's store link
      );
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: shareContent,
            child: Text('Share Content'),
          ),
        ],
      ),
    );
  }
}
