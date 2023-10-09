import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:habitshare/Constants/Constants.dart';
import 'package:intl/intl.dart';

import 'package:redux/redux.dart';

import '../AddHabit/AddHabitForm.dart';
import '../AddHabit/Habit.dart';
import '../Reducer/AppState.dart';

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
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddHabitForm()));
                },
                icon: Icon(Icons.arrow_back)),
            title: Text('HABIT SHARE'),
          ),
          body: Column(
            children: [
              TimelineCalendar(
                calendarType: CalendarType.GREGORIAN,
                calendarLanguage: "en",
                calendarOptions: CalendarOptions(
                  viewType: ViewType.DAILY,
                  toggleViewType: true,
                  headerMonthElevation: 10,
                  headerMonthShadowColor: Colors.black26,
                  headerMonthBackColor: Colors.transparent,
                ),
                dayOptions: DayOptions(
                    compactMode: true, weekDaySelectedColor: primaryColor),
                headerOptions: HeaderOptions(
                    weekDayStringType: WeekDayStringTypes.SHORT,
                    monthStringType: MonthStringTypes.FULL,
                    backgroundColor: primaryColor,
                    headerTextColor: Colors.black),
                onChangeDateTime: (datetime) {
                  print(datetime.getDate());
                },
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    // Check if the habit falls within the selected date range
                    if (habit.startDate.isAfter(store.state.startDate!) ||
                        habit.endDate.isBefore(store.state.endDate!)) {
                      // Habit is outside the selected date range, don't display it
                      return Container();
                    }
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
                                  RemoveCompletedHabitAction(habit.name),
                                );
                              } else {
                                completedHabits.add(selectedHabit!);

                                // Dispatch the action to add the habit to completedHabits
                                StoreProvider.of<AppState>(context).dispatch(
                                  AddCompletedHabitAction(habit),
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
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(
                                          '--- ${habit.habitType ?? 'N/A'}',
                                          style: TextStyle(
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
                                        Text(
                                          'Start Date: ${DateFormat.yMd().format(habit.startDate)}', // Format the start date
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          'End Date: ${DateFormat.yMd().format(habit.endDate)}', // Format the end date
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
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
                          color: getCardColor(completedHabit.habitType),
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

  Color getCardColor(String? habitType) {
    if (habitType == 'Build') {
      return Colors.green;
    } else if (habitType == 'Quit') {
      return Colors.red;
    }
    return Colors.blue; // Default color
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
