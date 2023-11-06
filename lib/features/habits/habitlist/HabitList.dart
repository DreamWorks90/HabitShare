import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/redux/AppState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';
import 'package:HabitShare/features/habits/addhabit/AddHabitForm.dart';
import 'package:HabitShare/features/habits/models/Habit.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitList extends StatefulWidget {
  const HabitList({Key? key});

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  DateTime selectedDate = DateTime.now();
  List<Habit> completedHabits = [];
  List<Habit> activeHabits = [];
  List<Habit> completedHabitsForToday = [];
  Map<DateTime, List<Habit>> habits = {};
  double _completedHabitsCardPosition = 0;
  bool _isCompletedHabitsCardVisible = false;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  void _toggleCompletedHabitsCardVisibility() {
    setState(() {
      _isCompletedHabitsCardVisible = !_isCompletedHabitsCardVisible;
      _completedHabitsCardPosition = _isCompletedHabitsCardVisible ? 0 : -300;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize completedHabits list with habits completed for the current date
    completedHabits = activeHabits
        .where((habit) =>
            habit.completionDate != null &&
            isSameDay(habit.completionDate! as DateTime?, selectedDate))
        .toList();

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
                  eventLoader: (day) {
                    // Map the habit objects to their corresponding event indicator (can be any widget)
                    return completedHabitsForToday
                        .where((habit) => isSameDay(
                            DateTime.parse(habit.completionDate!), day))
                        .map((habit) => const Icon(Icons
                            .check)) // Use Icons.check as an example, you can customize the indicator
                        .toList();
                  },
                  onDaySelected: (DateTime day, DateTime focusedDay) {
                    setState(() {
                      selectedDate = day;
                      completedHabitsForToday.clear();

                      for (var habit in habits) {
                        if (habit.completionDate != null) {
                          DateTime completionDate =
                              DateTime.parse(habit.completionDate!);
                          DateTime? termDate;
                          termDate = DateTime.parse(habit.termDate);

                          if (completionDate.isBefore(selectedDate) &&
                              (termDate.isAfter(selectedDate))) {
                            completedHabitsForToday.add(habit);
                          }
                        }
                      }
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
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 385, // Set the height of the first list
                          child: ListView.builder(
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
                                  isVisible = selectedDate.isAfter(startDate) &&
                                      selectedDate.isBefore(termDate);
                                } else {
                                  isVisible =
                                      true; // Display daily habits without start and term date restriction
                                }
                              } else if (habit.frequency ==
                                      HabitFrequency.weekend &&
                                  (selectedDate.weekday == DateTime.saturday ||
                                      selectedDate.weekday ==
                                          DateTime.sunday)) {
                                if (habit.termDate != null) {
                                  final startDate =
                                      DateTime.parse(habit.startDate);
                                  final termDate =
                                      DateTime.parse(habit.termDate);
                                  isVisible = selectedDate.isAfter(startDate) &&
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15, top: 2),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      color: getCardColor(habit.habitType),
                                      elevation: 4.0,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        leading: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 1),
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
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Text(
                                                  ' || ',
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Frequency:  ${habit.frequency.toString().split('.').last}',
                                                  style: const TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context, habit);
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Completed Habits',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              bottom: _completedHabitsCardPosition,
                              left: 0,
                              right: 0,
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.primaryDelta != null) {
                                    setState(() {
                                      _completedHabitsCardPosition +=
                                          details.primaryDelta!;
                                      if (_completedHabitsCardPosition > 0) {
                                        _completedHabitsCardPosition = 0;
                                      } else if (_completedHabitsCardPosition <
                                          -300) {
                                        // Set the height of the completed habits card
                                        _completedHabitsCardPosition = -300;
                                      }
                                    });
                                  }
                                },
                                onVerticalDragEnd: (details) {
                                  if (_completedHabitsCardPosition < -150) {
                                    // Set the threshold for card visibility
                                    _toggleCompletedHabitsCardVisibility();
                                  } else {
                                    _toggleCompletedHabitsCardVisibility();
                                  }
                                },
                                child: CompletedHabitsCard(
                                  completedHabits: completedHabits,
                                  onCardTapped:
                                      _toggleCompletedHabitsCardVisibility,
                                  getCardColor: getCardColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class CompletedHabitsCard extends StatefulWidget {
  final List<Habit> completedHabits;
  final VoidCallback onCardTapped;
  final Color Function(String?) getCardColor;

  const CompletedHabitsCard({
    super.key,
    required this.completedHabits,
    required this.onCardTapped,
    required this.getCardColor,
  });

  @override
  State<CompletedHabitsCard> createState() => _CompletedHabitsCardState();
}

class _CompletedHabitsCardState extends State<CompletedHabitsCard> {
  final ScrollController _scrollController = ScrollController();
  Color getCardColor(String? habitType) {
    return widget.getCardColor(habitType);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardTapped,
      child: Container(
        height: 125,
        width: 380,
        color: Colors.grey.shade200,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.completedHabits.length,
          itemBuilder: (context, index) {
            final completedHabit = widget.completedHabits[index];
            return Slidable(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: getCardColor(completedHabit.habitType),
                borderOnForeground: true,
                elevation: 4.0,
                shadowColor: const Color(0xff1855f4),
                margin: const EdgeInsets.symmetric(
                    horizontal: 17.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            completedHabit.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
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
    );
  }
}

void _showHabitDetailsDialog(BuildContext context, Habit habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          '${habit.name}',
          style: git const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
              'Start Date:  ${habit.startDate ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display start date if available, 'N/A' otherwise
            Text(
              'Term Date:  ${habit.termDate ?? 'N/A'}',
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
