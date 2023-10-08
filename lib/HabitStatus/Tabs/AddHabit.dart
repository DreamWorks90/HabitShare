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
          title: const Center(
        child: Text(
          "Add Habits",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      )),
    );
  }
}
