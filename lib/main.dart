import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:flutter/material.dart';
import 'Mongo DB/mongoloid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await syncLocalDatabaseWithMongoDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker App',
      home: HabitTrackerScreen(),
    );
  }
}

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashPage(),
    );
  }
}
