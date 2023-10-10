import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';
import 'package:redux/redux.dart';
import 'package:HabitShare/features/habits/addhabit/AddHabitForm.dart';
import 'package:HabitShare/features/habits/models/Habit.dart';

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
              automaticallyImplyLeading: false,
              backgroundColor: primaryColor,
              title: const Center(
                child: Text(
                  "Habit List",
                  style: appbarTextStyle,
                ),
              )),
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
                          color: getCardColor(habit.habitType),
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          habit.name,
                                          style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          '--- ${habit.habitType ?? 'N/A'}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Description: ${habit.description}',
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
                                        const SizedBox(
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
                    const Text(
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
                          color: getCardColor(completedHabit.habitType),
                          borderOnForeground: true,
                          elevation: 4.0,
                          shadowColor: Color(0xff1855f4),
                          margin: const EdgeInsets.symmetric(
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
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      completedHabit.description,
                                      style: const TextStyle(
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
              Navigator.of(context).push(_createRoute());
            },
            backgroundColor: primaryColor,
            child: const Icon(
              Icons.add,
              size: 25,
            ),
          ),
        );
      },
    );
  }

  Color getCardColor(String? habitType) {
    if (habitType == 'Build') {
      return Colors.green;
    } else if (habitType == 'Quit') {
      return Colors.red;
    }
    return Colors.blue; // Default color
  }
}

PageRouteBuilder _createRoute() {
  const duration = Duration(seconds: 1);
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddHabitForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve))
        ..animate(animation);
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: duration,
    reverseTransitionDuration: duration, // Set the animation duration here
  );
}

void _showDeleteConfirmationDialog(BuildContext context, Habit habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
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
