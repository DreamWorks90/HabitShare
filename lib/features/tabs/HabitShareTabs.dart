import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/features/habits/habitlist/HabitList.dart';
import 'package:HabitShare/features/reports/Reports.dart';
import 'package:HabitShare/features/settings/Settings.dart';
import 'package:HabitShare/features/friends/Friends.dart';
import 'package:flutter_svg/svg.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildBottomNavBarItem(0, 'assets/images/habit.svg', 'Habit'),
            buildBottomNavBarItem(1, 'assets/images/friends.svg', 'Friends'),
            buildBottomNavBarItem(3, 'assets/images/settings.svg', 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNavBarItem(int index, String iconPath, String label) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        color: index == _currentIndex ? primaryColor : Colors.transparent,
      ),
      child: IconButton(
        onPressed: () {
          _onItemTapped(index);
        },
        color: Colors.black, // Set the default color to black
        iconSize: 50,
        icon: Container(
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  iconPath,
                  color: index == _currentIndex ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: index == _currentIndex ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
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
