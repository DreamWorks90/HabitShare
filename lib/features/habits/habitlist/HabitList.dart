import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
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
        ScrollController _scrollController = ScrollController();
        bool _scrollEnabled = false;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: const Center(
              child: Text(
                "Habit List",
                style: appbarTextStyle,
              ),
            ),
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
                    compactMode: true,
                    weekDaySelectedColor: primaryColor,
                    disableDaysBeforeNow: true),
                headerOptions: HeaderOptions(
                    weekDayStringType: WeekDayStringTypes.SHORT,
                    monthStringType: MonthStringTypes.FULL,
                    backgroundColor: primaryColor,
                    headerTextColor: Colors.black),
                onChangeDateTime: (datetime) {
                  print(datetime.getDate());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 4),
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: getCardColor(habit.habitType),
                          elevation: 4.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: Radio(
                              value: habit,
                              groupValue: completedHabits.contains(habit)
                                  ? habit
                                  : null,
                              onChanged: (selectedHabit) {
                                setState(() {
                                  if (completedHabits.contains(selectedHabit)) {
                                    completedHabits.remove(selectedHabit);

                                    // Dispatch the action to remove the habit from completedHabits
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(
                                      RemoveCompletedHabitAction(
                                          selectedHabit!.name),
                                    );
                                  } else {
                                    completedHabits.add(selectedHabit!);

                                    // Dispatch the action to add the habit to completedHabits
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(
                                      AddCompletedHabitAction(selectedHabit),
                                    );
                                  }
                                });
                              },
                            ),
                            title: Text(
                              habit.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  habit.description,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    const Text(
                                      'Streak: ',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      ' || ',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Frequency:  ${habit.frequency.toString().split('.').last}',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, habit);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 8.0),
                    ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: completedHabits.length,
                      itemBuilder: (context, index) {
                        final completedHabit = completedHabits[index];
                        return Slidable(
                          child: Card(
                            color: getCardColor(completedHabit.habitType),
                            borderOnForeground: true,
                            elevation: 4.0,
                            shadowColor: const Color(0xff1855f4),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 17.0, vertical: 10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        completedHabit.name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        completedHabit.description,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8.0),
                                    ],
                                  ),
                                ],
                              ),
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
      return Colors.green.shade200;
    } else if (habitType == 'Quit') {
      return Colors.red.shade200;
    }
    return Colors.blue; // Default color
  }
}

PageRouteBuilder _createRoute() {
  const duration = Duration(seconds: 1);
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const AddHabitForm(),
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
            child: const Text('Cancel'),
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
