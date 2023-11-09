import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:HabitShare/redux/AppState.dart';

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
        debugShowCheckedModeBanner: false,
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
    return const Scaffold(
      body: HabitStatus(),
    );
  }
}
