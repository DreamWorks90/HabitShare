import 'package:add_habit_demo_3/add_habit_form.dart';
import 'package:add_habit_demo_3/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: const MaterialApp(
        title: 'Habit Tracker App',
        home: HabitTrackerScreen(),
      ),
    );
  }
}

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: const Column(
        children: <Widget>[
          AddHabitForm(),
          //HabitList(),
        ],
      ),
    );
  }
}
