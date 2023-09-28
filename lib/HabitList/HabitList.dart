/*import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare_dw/AddHabit/AddHabitForm.dart';
import 'package:habitshare_dw/AddHabit/Habit.dart';
import 'package:habitshare_dw/Reducer/AppState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                child: ListView(
                  children: habits
                      .map(
                        (habit) => Slidable(
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context) {
                                  _completeHabit(context, habit);
                                }),
                                backgroundColor: Colors.green,
                                icon: Icons.done_all,
                                label: 'Complete',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context) {
                                  _deleteHabit(context, habit);
                                }),
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Card(
                            elevation: 4.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                      SizedBox(width: 10.0),
                                      Icon(Icons.access_time),
                                      SizedBox(width: 4.0),
                                      Text(
                                          'Time: ${habit.time.toString().split('.').last}'),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                        color: Color(0xff1855f4),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedHabits.length,
                      itemBuilder: (context, index) {
                        final completedHabit = completedHabits[index];
                        return Card(
                          borderOnForeground: true,
                          elevation: 4.0,
                          shadowColor: Color(0xff1855f4),
                          margin: EdgeInsets.symmetric(
                              horizontal: 17.0, vertical: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      completedHabit.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      completedHabit.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddHabitForm()));
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
          ),
        );
      },
    );
  }

  void _completeHabit(BuildContext context, Habit habit) {
    // Remove the habit from the list of active habits
    StoreProvider.of<AppState>(context).dispatch(
      RemoveHabitAction(habit!.name),
    );

    // Add the habit to the list of completed habits
    setState(() {
      completedHabits.add(habit);
    });
  }

  void _deleteHabit(BuildContext context, Habit habit) {
    // Remove the habit from the list of active habits
    StoreProvider.of<AppState>(context).dispatch(
      RemoveHabitAction(habit.name),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare_dw/AddHabit/AddHabitForm.dart';
import 'package:habitshare_dw/AddHabit/Habit.dart';
import 'package:habitshare_dw/Reducer/AppState.dart';
import 'package:redux/redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import the Slidable package

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
        final completedHabits = store.state.completedHabits;
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
                    return Slidable(
                      // Use Slidable instead of Row
                      startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: ((context) {
                              _completed(context, habit);
                             //to be completed tasks
                            }),
                            backgroundColor: Colors.green,
                            icon: Icons.done_all,
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: ((context) {
                              _completed(context, habit); //call number
                            }),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),

                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  SizedBox(width: 10.0),
                                  Icon(Icons.access_time),
                                  SizedBox(width: 4.0),
                                  Text(
                                      'Time: ${habit.time.toString().split('.').last}'),
                                  SizedBox(
                                    width: 5.0,
                                  ),

                                ],
                              ),
                              // Add other habit information here
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Add the completed habits section here using Slidable as well
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddHabitForm()));
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
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

void _completed(BuildContext context, Habit habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      var completedHabits;
      return Container(
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
                color: Color(0xff1855f4),
              ),
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: completedHabits.length,
              itemBuilder: (context, index) {
                final completedHabit = completedHabits[index];
                return Card(
                  borderOnForeground: true,
                  elevation: 4.0,
                  shadowColor: Color(0xff1855f4),
                  margin: EdgeInsets.symmetric(
                      horizontal: 17.0, vertical: 10.0),
                  child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              completedHabit.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              completedHabit.description,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}*/

/*import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare_dw/AddHabit/AddHabitForm.dart';
import 'package:habitshare_dw/AddHabit/Habit.dart';
import 'package:habitshare_dw/Reducer/AppState.dart';

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
        final completedHabits = store.state.completedHabits;
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

                                // Dispatch the action to remove the habit from completedHabits
                                StoreProvider.of<AppState>(context).dispatch(
                                  RemoveCompletedHabitAction(
                                      selectedHabit!.name),
                                );
                              } else {
                                completedHabits.add(selectedHabit!);

                                // Dispatch the action to add the habit to completedHabits
                                StoreProvider.of<AppState>(context).dispatch(
                                  AddCompletedHabitAction(selectedHabit),
                                );
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
                        color: Color(0xff1855f4),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedHabits.length,
                      itemBuilder: (context, index) {
                        final completedHabit = completedHabits[index];
                        return Card(
                          borderOnForeground: true,
                          elevation: 4.0,
                          shadowColor: Color(0xff1855f4),
                          margin: EdgeInsets.symmetric(
                              horizontal: 17.0, vertical: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      completedHabit.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      completedHabit.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddHabitForm()));
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
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
*/

// original

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:habitshare_dw/AddHabit/AddHabitForm.dart';
import 'package:habitshare_dw/AddHabit/Habit.dart';
import 'package:habitshare_dw/Reducer/AppState.dart';

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
        final completedHabits = store.state.completedHabits;
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

                                // Dispatch the action to remove the habit from completedHabits
                                StoreProvider.of<AppState>(context).dispatch(
                                  RemoveCompletedHabitAction(
                                      selectedHabit!.name),
                                );
                              } else {
                                completedHabits.add(selectedHabit!);

                                // Dispatch the action to add the habit to completedHabits
                                StoreProvider.of<AppState>(context).dispatch(
                                  AddCompletedHabitAction(selectedHabit),
                                );
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
                        color: Color(0xff1855f4),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: completedHabits.length,
                      itemBuilder: (context, index) {
                        final completedHabit = completedHabits[index];
                        return Card(
                          borderOnForeground: true,
                          elevation: 4.0,
                          shadowColor: Color(0xff1855f4),
                          margin: EdgeInsets.symmetric(
                              horizontal: 17.0, vertical: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      completedHabit.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      completedHabit.description,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddHabitForm()));
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
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
