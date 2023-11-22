import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/features/habits/habitlist/HabitList.dart';
import 'package:HabitShare/features/reports/Reports.dart';
import 'package:HabitShare/features/settings/Settings.dart';
import 'package:HabitShare/features/friends/Friends.dart';

class HabitStatus extends StatefulWidget {
  const HabitStatus({super.key});

  @override
  State<HabitStatus> createState() => _HabitStatusState();
}

class _HabitStatusState extends State<HabitStatus> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HabitList(),
    const FriendsTab(
      selectedFriends: [],
    ),
    const ReportsTab(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 10,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.assignment),
              color: primaryColor,
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            IconButton(
              icon: const Icon(Icons.group),
              color: primaryColor,
              onPressed: () {
                _onItemTapped(1);
              },
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              color: primaryColor,
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: primaryColor,
              onPressed: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
