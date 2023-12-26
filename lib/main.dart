import 'package:HabitShare/MongoDb/mongolocaldb.dart';
import 'package:HabitShare/Realm/habit.dart';
import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';
import 'package:realm/realm.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

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
      body: SplashPage(),
    );
  }
}
