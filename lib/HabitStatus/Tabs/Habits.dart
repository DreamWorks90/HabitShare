import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';

class HabitsTab extends StatefulWidget {
  const HabitsTab({super.key});

  @override
  State<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends State<HabitsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signInWidget));
              },
              icon: arrowBackIcon),
          title: Center(
            child: Text(
              "Habits",
              style: appbarTextStyle,
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Text('Habits Tab Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => addHabitsWidget));
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
