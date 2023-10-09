import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';

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
            icon: const Icon(Icons.person),
            onPressed: toggleButtonsVisibility,
          ),
        ],
        title: const Center(
          child: Text("Friends", style: appbarTextStyle),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: areButtonsVisible,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Hello")
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