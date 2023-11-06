import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/friends/addfriends/LinkShare.dart';
import 'package:HabitShare/features/friends/addfriends/QRCode.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter/material.dart';

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
              title: const Center(
                  child: Text("Add Friends", style: appbarTextStyle)),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: togglePopover,
                ),
              ],
              title: const Center(
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRCode()));
                      },
                      child: const Text("QR Code", style: buttonTextStyle),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LinkShare()));
                      },
                      child: const Text(
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
