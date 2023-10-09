import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare/HomePage/SplashPage.dart';
import 'package:habitshare/Reducer/AppState.dart';

void main() {
  runApp(MyApp());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: SplashPage(),
    );
  }
}
