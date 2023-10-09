import 'package:flutter/material.dart';
import 'package:habitshare/HabitList/HabitList.dart';

class FooterPage extends StatefulWidget {
  const FooterPage({super.key});

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HabitList()));
                    },
                    icon: Icon(Icons.event_note_sharp)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.event_note_sharp)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.event_note_sharp)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.event_note_sharp)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Habit List'),
                Text('Habit List'),
                Text('Habit List'),
                Text('Habit List'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
