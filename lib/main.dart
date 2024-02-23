import 'package:HabitShare/features/splash/SplashPage.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Mongo DB/mongoloid.dart';
import 'features/friends/addfriends/current_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await syncLocalDatabaseWithMongoDB();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()), // Provide the NotificationProvider
      ],
      child: const MyApp(),
    ),
  );
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



