import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("firebase before");
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDr6feO4K78mhMI_MyhHw6URVyX6SLC_gk",
      appId: "1:318897085152:android:4f81b94e706e14911a0e85",
      messagingSenderId: "318897085152",
      projectId: "habitshare-11.appspot.com",
    ),
  );
  //FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  print("firebase after");
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
      body: const SplashPage(),
    );
  }
}
