// lib/widgets/habit_list.dart
/*
import 'package:add_habit_demo_3/app_state.dart';
import 'package:add_habit_demo_3/habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HabitList extends StatelessWidget {
  const HabitList({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Habit>>(
      converter: (store) => store.state.habits,
      builder: (context, habits) {
        return ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return ListTile(
              title: Text(habit.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.description),
                  Text(
                      'Frequency: ${habit.frequency.toString().split('.').last}'),
                  Text('Time: ${habit.time.toString().split('.').last}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    RemoveHabitAction(habit.name),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
*/
