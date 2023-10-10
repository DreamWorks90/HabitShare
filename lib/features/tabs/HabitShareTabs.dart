import 'package:flutter/material.dart';
import 'package:HabitShare/features/habits/habitlist/HabitList.dart';
import 'package:HabitShare/features/reports/Reports.dart';
import 'package:HabitShare/features/settings/Settings.dart';
import 'package:HabitShare/features/friends/Friends.dart';
import 'package:HabitShare/Constants.dart';

class HabitStatus extends StatefulWidget {
  const HabitStatus({super.key});

  @override
  State<HabitStatus> createState() => _HabitStatusState();
}

class _HabitStatusState extends State<HabitStatus> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HabitList(),
    const FriendsTab(),
    const ReportsTab(),
    const SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Habits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Friends",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Reports",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        //backgroundColor: primaryColor,
      ),
    );
  }
}
