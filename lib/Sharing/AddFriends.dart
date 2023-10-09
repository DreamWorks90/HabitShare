import 'package:flutter/material.dart';
import 'package:habitshare/HabitStatus/HabitStatus.dart';
import 'package:habitshare/HabitStatus/footerPage.dart';

class FriendsTab1 extends StatefulWidget {
  const FriendsTab1({super.key});

  @override
  State<FriendsTab1> createState() => _FriendsTab1State();
}

class _FriendsTab1State extends State<FriendsTab1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FooterPage(),
    );
  }
}
