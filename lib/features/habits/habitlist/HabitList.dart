import 'package:HabitShare/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:redux/redux.dart';
import 'package:HabitShare/features/habits/addhabit/AddHabitForm.dart';
import 'package:HabitShare/features/habits/models/HabitModel.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitList extends StatefulWidget {
  const HabitList({Key? key});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  DateTime selectedDate = DateTime.now();
  List<HabitModel> completedHabits = [];
  List<HabitModel> activeHabits = [];
  List<HabitModel> completedHabitsForToday = [];

  Map<DateTime, List<HabitModel>> habits = {};
  bool isVisible = true;

  int _currentSegment = 0; // Added to keep track of the selected segment

  @override
  Widget build(BuildContext context) {
    // Initialize completedHabits list with habits completed for the current date
    completedHabits = activeHabits
        .where((habit) =>
            habit.completionDate != null &&
            isSameDay(habit.completionDate! as DateTime?, selectedDate))
        .toList();

    return StoreConnector<AppState, List<HabitModel>>(
      converter: (Store<AppState> store) => store.state.habits,
      builder: (BuildContext context, List<HabitModel> habits) {
        final completedHabits = store.state.completedHabits;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_pic.jpg'),
                  // Replace 'assets/profile_pic.jpg' with the path to the user's profile picture
                  radius: 20,
                ),
                const SizedBox(width: 10),
                // Add user name here (you can replace the placeholder with your logic)
                Text(
                  'App Bar', // Replace 'User Name' with the actual user's name
                  style: appbarTextStyle,
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                TableCalendar(
                  // firstDay: DateTime.utc(2010, 10, 16),
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: selectedDate,
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  availableGestures: AvailableGestures.all,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: CalendarFormat.week,
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: (DateTime day, DateTime focusedDay) {
                    setState(() {
                      // Check if the selected day is the current date
                      if (isSameDay(day, selectedDate)) {
                        // Move habits from active list to completed list for one day
                        for (var completedHabit in completedHabits) {
                          // Remove from completedHabits
                          completedHabits.remove(completedHabit);

                          // Add to activeHabits
                          activeHabits.add(completedHabit);

                          // Update the completionDate to null (resetting it)
                          completedHabit.completionDate = null;
                        }
                      } else {
                        // Move habits back from completed list to active list
                        if (completedHabits.isNotEmpty) {
                          for (var completedHabit in completedHabits) {
                            // Remove from completedHabits
                            completedHabits.remove(completedHabit);

                            // Add to activeHabits
                            activeHabits.add(completedHabit);

                            // Update the completionDate to null (resetting it)
                            completedHabit.completionDate = null;
                          }
                        }
                      }

                      selectedDate = day;
                    });
                  },

                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  onFormatChanged: (format) {
                    // Do something when the calendar format changes (month/week/day)
                  },
                  onPageChanged: (focusedDay) {
                    //  _focusedDay=focusedDay;
                    // Do something when the visible page changes
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  child: CupertinoSegmentedControl<int>(
                    groupValue: _currentSegment,
                    onValueChanged: (value) {
                      setState(() {
                        _currentSegment = value;
                      });
                    },
                    children: {
                      0: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 16),
                        child: Text(
                          'Habits',
                          style: TextStyle(
                            fontSize: 16,
                            color: _currentSegment == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      1: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: Text(
                          'Completed Habits',
                          style: TextStyle(
                            fontSize: 16,
                            color: _currentSegment == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    },
                    unselectedColor: Colors.grey[300],
                    selectedColor: primaryColor, // Customize the selected color
                    borderColor: primaryColor, // Customize the border color
                    pressedColor: Colors.white, // Customize the pressed color
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _currentSegment == 0,
                  child: Expanded(
                    child: SizedBox(
                      height: 385, // Set the height of the first list
                      child: habits.isEmpty
                          ? Center(
                              child: SvgPicture.asset(
                                'assets/images/habitlistpic.svg',
                                height: 350,
                              ),
                            )
                          : ListView.builder(
                              itemCount: habits.length,
                              itemBuilder: (context, index) {
                                final habit = habits[index];

                                bool isVisible = false;
                                if (habit.frequency == HabitFrequency.daily) {
                                  if (habit.termDate != null) {
                                    final startDate =
                                        DateTime.parse(habit.startDate);
                                    final termDate =
                                        DateTime.parse(habit.termDate);
                                    isVisible =
                                        selectedDate.isAfter(startDate) &&
                                            selectedDate.isBefore(termDate);
                                  } else {
                                    isVisible =
                                        true; // Display daily habits without start and term date restriction
                                  }
                                } else if (habit.frequency ==
                                        HabitFrequency.weekend &&
                                    (selectedDate.weekday ==
                                            DateTime.saturday ||
                                        selectedDate.weekday ==
                                            DateTime.sunday)) {
                                  if (habit.termDate != null) {
                                    final startDate =
                                        DateTime.parse(habit.startDate);
                                    final termDate =
                                        DateTime.parse(habit.termDate);
                                    isVisible =
                                        selectedDate.isAfter(startDate) &&
                                            selectedDate.isBefore(termDate);
                                  } else {
                                    isVisible =
                                        true; // Display weekend habits without start and term date restriction
                                  }
                                } else if (habit.frequency ==
                                    HabitFrequency.weekly) {
                                  final startDate =
                                      DateTime.parse(habit.startDate);

                                  // Check if the selected date is in the next 7 days and is the same weekday as the habit's weekday
                                  final next7Days = List.generate(
                                      7,
                                      (index) => selectedDate
                                          .add(Duration(days: index)));
                                  isVisible = next7Days.any((date) =>
                                      isSameDay(date, selectedDate) &&
                                      date.weekday == startDate.weekday);

                                  // Check if the selected date is before the habit's term date
                                  if (isVisible) {
                                    final termDate =
                                        DateTime.parse(habit.termDate);
                                    isVisible = selectedDate.isBefore(termDate);
                                  }
                                }
                                if (isVisible) {
                                  return GestureDetector(
                                    onTap: () {
                                      _showHabitDetailsDialog(context, habit);
                                    },
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Radio(
                                            value: habit,
                                            groupValue:
                                                completedHabits.contains(habit)
                                                    ? habit
                                                    : null,
                                            onChanged: (selectedHabit) {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirm Habit Completion'),
                                                    content: const Text(
                                                        'Have you completed this habit?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text(
                                                            'Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop(); // Close the dialog
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (completedHabits
                                                                .contains(
                                                                    selectedHabit)) {
                                                              completedHabits
                                                                  .remove(
                                                                      selectedHabit);
                                                              // Dispatch the action to remove the habit from completedHabits
                                                              StoreProvider.of<
                                                                          AppState>(
                                                                      context)
                                                                  .dispatch(
                                                                RemoveCompletedHabitAction(
                                                                    selectedHabit!
                                                                        .name),
                                                              );
                                                            } else {
                                                              completedHabits.add(
                                                                  selectedHabit!);
                                                              // Dispatch the action to add the habit to completedHabits
                                                              StoreProvider.of<
                                                                          AppState>(
                                                                      context)
                                                                  .dispatch(
                                                                AddCompletedHabitAction(
                                                                    selectedHabit),
                                                              );
                                                            }
                                                          });
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop(); // Close the dialog
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 2),
                                          child: Card(
                                            color:
                                                getCardColor(habit.habitType),
                                            elevation: 4.0,
                                            child: Container(
                                              height: 95,
                                              width: 310,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    width: 4,
                                                    color: getBorderColor(
                                                        habit.habitType),
                                                  ),
                                                ),
                                              ),
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.all(10.0),
                                                title: Text(
                                                  habit.name.toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      habit.description,
                                                      style: const TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/images/streak.svg',
                                                          height: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Text(
                                                          'Streak',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        SvgPicture.asset(
                                                          'assets/images/calendar.svg',
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          '  ${habit.frequency.toString().split('.').last}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                trailing:
                                                    PopupMenuButton<String>(
                                                  onSelected: (value) {
                                                    // Handle the selected option
                                                    if (value == 'delete') {
                                                      _showDeleteConfirmationDialog(
                                                          context, habit);
                                                    } else if (value ==
                                                        'edit') {
                                                      // Implement edit functionality
                                                    } else if (value ==
                                                        'shareFriends') {
                                                      // Implement share with friends functionality
                                                    }
                                                  },
                                                  itemBuilder: (BuildContext
                                                          context) =>
                                                      <PopupMenuEntry<String>>[
                                                    const PopupMenuItem<String>(
                                                      value: 'edit',
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.edit),
                                                        title: Text('Edit'),
                                                      ),
                                                    ),
                                                    const PopupMenuItem<String>(
                                                      value: 'delete',
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.delete),
                                                        title: Text('Delete'),
                                                      ),
                                                    ),
                                                    const PopupMenuItem<String>(
                                                      value: 'shareFriends',
                                                      child: ListTile(
                                                        leading:
                                                            Icon(Icons.share),
                                                        title: Text(
                                                            'Share with Friends'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _currentSegment == 1,
                  child: Expanded(
                    child: SizedBox(
                      height: 200, // Set the height of the second list
                      child: completedHabits.isEmpty
                          ? Center(
                              child: SvgPicture.asset(
                                'assets/images/notcompleted.svg',
                                height: 350,
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: completedHabits.length,
                              itemBuilder: (context, index) {
                                final completedHabit = completedHabits[index];
                                return Slidable(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    color:
                                        getCardColor(completedHabit.habitType),
                                    borderOnForeground: true,
                                    elevation: 4.0,
                                    shadowColor: const Color(0xff1855f4),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 17.0, vertical: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Center(
                                              child: Text(
                                                completedHabit.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            subtitle: Center(
                                              child: Text(
                                                completedHabit.description,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
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
      return const Color(0xFFD8FAD2);
    } else if (habitType == 'Quit') {
      return const Color(0xffffefe4);
    }
    return Colors.blue; // Default color
  }

  Color getBorderColor(String? habitType) {
    if (habitType == 'Build') {
      return Colors.green;
    } else if (habitType == 'Quit') {
      return Colors.red;
    }
    return Colors.blue; // Default color
  }

  Color getColorForHabitType(String? habitType) {
    if (habitType == 'Build') {
      return Colors.green;
    } else if (habitType == 'Quit') {
      return Colors.red;
    }
    return Colors.black; // Default color
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

void _showDeleteConfirmationDialog(BuildContext context, HabitModel habit) {
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

void _showHabitDetailsDialog(BuildContext context, HabitModel habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          '${habit.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Habit Description:  ${habit.description}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Frequency:  ${habit.frequency.toString().split('.').last}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Time:  ${habit.time.toString().split('.').last}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display habit time if available, 'N/A' otherwise
            Text(
              'Start Date:  ${habit.startDate}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display start date if available, 'N/A' otherwise
            Text(
              'Term Date:  ${habit.termDate}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display term date if available, 'N/A' otherwise            // Add more details like time, start date, term date, streak, etc.
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
