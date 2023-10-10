import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'AddFriends/LinkShare.dart';
import 'AddFriends/QRCode.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  bool isPopoverVisible = false;

  // Function to toggle the visibility of the popover
  void togglePopover() {
    setState(() {
      isPopoverVisible = !isPopoverVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPopoverVisible
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              title: Center(child: Text("Add Friends", style: appbarTextStyle)),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: togglePopover,
                ),
              ],
              title: Center(
                child: Text("Friends", style: appbarTextStyle),
              ),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Conditionally show the popover
            if (isPopoverVisible)
              Container(
                //height: 700,
                //width: 350,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
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
    );
  }
}
