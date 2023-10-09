import 'package:flutter/material.dart';
import 'package:habitshare/Authentication/SignIn.dart';
import 'package:habitshare/Authentication/SignUp.dart';

import '../Constants/Constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                child: Text(
                  'Habit Share',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: const Text('Sign Up', style: buttonTextStyle),
          ),
          SizedBox(width: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Text(
              'Sign In',
              style: buttonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
