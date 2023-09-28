import 'package:flutter/material.dart';
import 'package:habitshare_dw/Constants/Constants.dart';
import 'package:habitshare_dw/Sharing/LinkShare.dart';
import 'package:habitshare_dw/Sharing/QRCode.dart';

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
            onPressed: toggleButtonsVisibility,
          ),
        ],
        title: Center(
          child: Text("Friends", style: appbarTextStyle),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: areButtonsVisible,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => QRCode()));
                      },
                      child: Text("QR Code", style: buttonTextStyle),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LinkShare()));
                      },
                      child: Text(
                        "Via Link Share",
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
