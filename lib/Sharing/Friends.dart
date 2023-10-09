import 'package:flutter/material.dart';
import 'package:habitshare/Constants/Constants.dart';
import 'package:habitshare/Sharing/AddFriends.dart';
import 'package:habitshare/Sharing/LinkShare.dart';
import 'package:habitshare/Sharing/QRCode.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  bool areButtonsVisible = false;
  void toggleButtonsVisibility() {
    setState(() {
      areButtonsVisible = !areButtonsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FriendsTab1()));
            },
          ),
        ],
        title: Center(
          child: Text("Friends", style: appbarTextStyle),
        ),
      ),
    );
  }
}
