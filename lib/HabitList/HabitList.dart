// lib/widgets/habit_list.dart

import 'package:add_habit_demo_3/AddHabit/habit.dart';
import 'package:add_habit_demo_3/Reducer/AppState.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HabitList extends StatelessWidget {
  const HabitList({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Habit>>(
      converter: (Store<AppState> store) => store.state.habits,
      builder: (BuildContext context, List<Habit> habits) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text('HABIT SHARE'),
            ),
            body: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          habit.description,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 4.0),
                            Text(
                                'Frequency:  ${habit.frequency.toString().split('.').last}'),
                            SizedBox(width: 16.0),
                            Icon(Icons.access_time),
                            SizedBox(width: 4.0),
                            Text(
                                'Time: ${habit.time.toString().split('.').last}'),
                            SizedBox(
                              width: 5.0,
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                  RemoveHabitAction(habit.name),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_outlined),
            ),
          ),
        );
      },
    );
  }
}
