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
        title: 'Share Content',
        text: 'Check out this link:',
        linkUrl: 'https://example.com',
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
