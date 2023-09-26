import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare/AddHabit/Habit.dart';
import 'package:habitshare/Reducer/AppState.dart';
import 'package:redux/redux.dart';

class HabitList extends StatefulWidget {
  const HabitList({Key? key});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  List<Habit> completedHabits = [];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Habit>>(
      converter: (Store<AppState> store) => store.state.habits,
      builder: (BuildContext context, List<Habit> habits) {
        return Scaffold(
          appBar: AppBar(
            title: Text('HABIT SHARE'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    return Row(
                      children: [
                        Radio(
                          value: habit,
                          groupValue:
                              completedHabits.contains(habit) ? habit : null,
                          onChanged: (selectedHabit) {
                            setState(() {
                              if (completedHabits.contains(selectedHabit)) {
                                completedHabits.remove(selectedHabit);
                              } else {
                                completedHabits.add(selectedHabit!);
                              }
                            });
                          },
                        ),
                        Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
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
                                        SizedBox(width: 10.0),
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
                                            _showDeleteConfirmationDialog(
                                                context, habit);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Habits',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedHabits.length,
                      itemBuilder: (context, index) {
                        final completedHabit = completedHabits[index];
                        return ListTile(
                          title: Text(completedHabit.name),
                          subtitle: Text(completedHabit.description),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_outlined),
          ),
        );
      },
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, Habit habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this habit?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              // Dispatch the action to delete the habit
              StoreProvider.of<AppState>(context).dispatch(
                RemoveHabitAction(habit.name),
              );
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
