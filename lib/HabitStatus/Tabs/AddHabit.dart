import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';

class AddHabits extends StatefulWidget {
  const AddHabits({super.key});
  @override
  State<AddHabits> createState() => _AddHabitsState();
}

class _AddHabitsState extends State<AddHabits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          title: Center(
            child: Text("Add Habits", style: appbarTextStyle),
          )),
    );
  }
}
