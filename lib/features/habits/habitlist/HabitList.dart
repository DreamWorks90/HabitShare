import 'dart:async';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/Realm/habit.dart';
import 'package:HabitShare/features/habits/EditHabit/edit_habit_form.dart';
import 'package:HabitShare/features/habits/habitlist/sharewithfriends.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:realm/realm.dart';
import 'package:table_calendar/table_calendar.dart';
import 'habit_list_utils.dart';

class HabitList extends StatefulWidget {
  const HabitList({Key? key});
  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  late Realm realm;
  bool isRealmInitialized = false; // Track initialization
  DateTime selectedDate = DateTime.now();
  List<HabitModel> completedHabits = [];
  List<HabitModel> activeHabits = [];
  Map<DateTime, List<HabitModel>> habits = {};
  int _currentSegment = 0;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    _initializeRealm();
  }

  void _refreshHabitList() {
    setState(() {
      // Fetch and update habits from the realm
      final habits = realm.all<HabitModel>();
      activeHabits = habits.where((habit) => !habit.isCompletedToday).toList();
      completedHabits =
          habits.where((habit) => habit.isCompletedToday).toList();
    });
  }

  Future<void> _initializeRealm() async {
    try {
      final config = Configuration.local(
          [HabitModel.schema]); // Customize Realm configuration here
      realm = await Realm.open(config);
      setState(() {
        isRealmInitialized = true;
      });
    } catch (e) {
      print('Error initializing Realm: $e');
    } // Trigger a rebuild after Realm is initialized
  }

  int calculateTotalDays(HabitModel habit) {
    if (habit.startDate.isEmpty || habit.termDate.isEmpty) {
      return 0; // Unable to calculate total days if start or term date is not provided
    }
    final DateTime startDateTime = DateTime.parse(habit.startDate);
    final DateTime termDateTime = DateTime.parse(habit.termDate);
    return termDateTime.difference(startDateTime).inDays + 1;
  }

  double calculateCompletionPercentage(HabitModel habit) {
    final int totalDays = calculateTotalDays(habit);
    if (totalDays == 0) {
      return 0.0; // To avoid division by zero
    }
    return (habit.totalCompletedDays / totalDays) * 100;
  }

  @override
  Widget build(BuildContext context) {
    if (!isRealmInitialized) {
      return const Center(child: CircularProgressIndicator());
    } else {
      final habits = realm.all<HabitModel>();
      activeHabits = habits.where((habit) => !habit.isCompletedToday).toList();
      completedHabits =
          habits.where((habit) => habit.isCompletedToday).toList();
      // Check and update isCompletedToday for each completed habit
      for (var completedHabit in completedHabits) {
        final completionDate = DateTime.parse(completedHabit.completionDate);
        final currentDate = DateTime.now();
        // Compare the current date with the completion date
        if (completedHabit.frequency == 'HabitFrequency.daily') {
          if (currentDate.isAfter(completionDate) &&
              !isSameDay(currentDate, completionDate)) {
            // If the current date is after completionDate and not the same day, update isCompletedToday to false
            realm.write(() {
              completedHabit.isCompletedToday = false;
            });
            setState(() {
              activeHabits.add(completedHabit);
            });
          }
        } else if (completedHabit.frequency == 'HabitFrequency.weekly') {
          final startDate = DateTime.parse(completedHabit.startDate);
          final termDate = DateTime.parse(completedHabit.termDate);
          DateTime nextOccurrence = startDate.add(const Duration(days: 7));
          while (nextOccurrence.isBefore(termDate) ||
              isSameDay(nextOccurrence, termDate)) {
            if (isSameDay(nextOccurrence, currentDate)) {
              realm.write(() {
                completedHabit.isCompletedToday = false;
              });
              setState(() {
                activeHabits.add(completedHabit);
              });
              break;
            }
            nextOccurrence = nextOccurrence.add(const Duration(days: 7));
          }
        } else if (completedHabit.frequency == 'HabitFrequency.weekend') {
          if (((currentDate.weekday == DateTime.sunday) ||
                  (currentDate.weekday == DateTime.saturday)) &&
              !isSameDay(currentDate, completionDate)) {
            // Update isCompletedToday to false for Sunday
            realm.write(() {
              completedHabit.isCompletedToday = false;
            }); // Move habit from active to completed list
            setState(() {
              activeHabits.add(completedHabit);
            });
          }
        }
      }
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/profile_pic.jpg'),
                radius: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Habit List', // Replace 'User Name' with the actual user's name
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
                    if (isSameDay(day, selectedDate)) {
                      for (var completedHabit in completedHabits) {
                        completedHabits.remove(completedHabit);
                        activeHabits.add(completedHabit);
                        completedHabit.termDate = null.toString();
                      }
                    } else {
                      if (completedHabits.isNotEmpty) {
                        for (var completedHabit in completedHabits) {
                          completedHabits.remove(completedHabit);
                          activeHabits.add(completedHabit);
                          completedHabit.termDate = null.toString();
                        }
                      }
                    }
                    selectedDate = day;
                  });
                },
                selectedDayPredicate: (day) => isSameDay(day, selectedDate),
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
                            itemCount: activeHabits.length,
                            itemBuilder: (context, index) {
                              final habit = activeHabits[index];
                              bool shouldDisplay = false;
                              final startDate = DateTime.parse(habit.startDate);
                              final termDate = DateTime.parse(habit.termDate);
                              int totalDays = calculateTotalDays(habit);
                              double completionPercentage =
                                  calculateCompletionPercentage(habit);
                              if (habit.frequency == 'HabitFrequency.daily') {
                                shouldDisplay =
                                    selectedDate.isAfter(startDate) &&
                                        (selectedDate.isBefore(termDate) ||
                                            isSameDay(selectedDate, termDate));
                              } else if (habit.frequency ==
                                  'HabitFrequency.weekend') {
                                shouldDisplay = (selectedDate.weekday ==
                                            DateTime.saturday ||
                                        selectedDate.weekday ==
                                            DateTime.sunday) &&
                                    selectedDate.isAfter(startDate) &&
                                    (selectedDate.isBefore(termDate) ||
                                        isSameDay(selectedDate, termDate));
                              } else if (habit.frequency ==
                                  'HabitFrequency.weekly') {
                                DateTime nextOccurrence = startDate;
                                while (nextOccurrence.isBefore(termDate)) {
                                  if (nextOccurrence.isAfter(selectedDate)) {
                                    break;
                                  }
                                  if (isSameDay(nextOccurrence, selectedDate)) {
                                    shouldDisplay = true;
                                    break;
                                  }
                                  nextOccurrence = nextOccurrence
                                      .add(const Duration(days: 7));
                                }
                                shouldDisplay = shouldDisplay &&
                                    (selectedDate.isBefore(termDate) ||
                                        isSameDay(selectedDate, termDate));
                              }
                              if (shouldDisplay) {
                                final String percentage =
                                    '%: ${completionPercentage.toStringAsFixed(2)}%';
                                return GestureDetector(
                                  onTap: () {
                                    showHabitDetailsDialog(context, habit);
                                  },
                                  child: Card(
                                    elevation: 4.0,
                                    color: getCardColor(habit.habitType),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex:
                                                0, // Set flex to 0 to ensure it only takes the space needed
                                            child: Container(
                                              height: 80,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    color: getBorderColor(habit
                                                        .habitType), // Your border color here

                                                    width: 5,
                                                    // Adjust the width of the border
                                                  ),
                                                ),
                                              ),
                                              padding: EdgeInsets.only(
                                                  left:
                                                      1.0), // Adjust padding as needed
                                              child: Radio(
                                                value: habit,
                                                groupValue: completedHabits
                                                        .contains(habit)
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
                                                            child: const Text(
                                                                'Yes'),
                                                            onPressed:
                                                                () async {
                                                              realm.write(() {
                                                                habit.isCompletedToday =
                                                                    true;
                                                                habit.streak++;
                                                                habit
                                                                    .totalCompletedDays++;

                                                                // Update completionDate with the current date
                                                                habit.completionDate =
                                                                    DateTime.now()
                                                                        .toString();
                                                                // Increment streak if applicable
                                                                if (habit.frequency == 'HabitFrequency.daily' ||
                                                                    habit.frequency ==
                                                                        'HabitFrequency.weekend' ||
                                                                    habit.frequency ==
                                                                        'HabitFrequency.weekly') {
                                                                  // Check streak continuation
                                                                  if (isStreakContinued(
                                                                      habit)) {
                                                                    habit
                                                                        .streak++;
                                                                  }
                                                                } else {
                                                                  // For other frequencies, reset streak
                                                                  habit.streak =
                                                                      1;
                                                                }

                                                                if (habit
                                                                        .termDate !=
                                                                    null) {
                                                                  // Check if termDate is available
                                                                  final DateTime
                                                                      currentDate =
                                                                      DateTime
                                                                          .now();
                                                                  final DateTime
                                                                      termDate =
                                                                      DateTime.parse(
                                                                          habit
                                                                              .termDate!);
                                                                  // If the current date is before or equal to the term date, increment totalCompletedDays
                                                                  if (currentDate
                                                                          .isBefore(
                                                                              termDate) ||
                                                                      currentDate
                                                                          .isAtSameMomentAs(
                                                                              termDate)) {
                                                                    habit.totalCompletedDays +=
                                                                        1;
                                                                  }
                                                                } else {
                                                                  // If termDate is null, always increment totalCompletedDays
                                                                  habit.totalCompletedDays +=
                                                                      1;
                                                                }
                                                                // Update completionDate with the current date
                                                                habit.completionDate =
                                                                    DateTime.now()
                                                                        .toString();
                                                              });

                                                              // Move habit from active to completed list
                                                              setState(() {
                                                                activeHabits.remove(
                                                                    selectedHabit);
                                                                completedHabits.add(
                                                                    selectedHabit!);
                                                              });
                                                              // Update habit in Realm (if needed)
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
                                          ),
                                          SizedBox(width: 5.0),
                                          Expanded(
                                            flex:
                                                1, // Ensure the habit details take the remaining space
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  habit.name.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: getColorForHabitType(
                                                        habit.habitType),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  habit.description,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[700],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 12.0),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/streak.svg',
                                                      height: 20,
                                                    ),
                                                    SizedBox(width: 5),
                                                    if (habit.streak >= 3)
                                                      Text(
                                                        habit.streak.toString(),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    SizedBox(width: 15),
                                                    SvgPicture.asset(
                                                      'assets/images/calendar.svg',
                                                      height: 20,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      habit.frequency
                                                          .toString()
                                                          .split('.')
                                                          .last,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      percentage,
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'delete') {
                                                showDeleteConfirmationDialog(
                                                    context, realm, habit);
                                              } else if (value == 'edit') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditHabitForm(
                                                      habit: habit,
                                                      refreshHabitList:
                                                          _refreshHabitList,
                                                    ),
                                                  ),
                                                );
                                              } else if (value ==
                                                  'shareFriends') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ShareWithFriends(
                                                              selectedFriends: [],
                                                            )));
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('Edit'),
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text('Delete'),
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'shareFriends',
                                                child: ListTile(
                                                  leading: Icon(Icons.share),
                                                  title: Text(
                                                      'Share with Friends'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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

                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: getCardColor(completedHabit.habitType),
                                borderOnForeground: true,
                                elevation: 4.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 17.0, vertical: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: getBorderColor(
                                                  completedHabit.habitType),
                                              width: 5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              completedHabit.name.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: getColorForHabitType(
                                                    completedHabit.habitType),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              completedHabit.description,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/streak.svg',
                                                  height: 20,
                                                ),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  completedHabit.streak
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
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
            Navigator.of(context).push(createRoute());
          },
          backgroundColor: primaryColor,
          child: const Icon(
            Icons.add,
            size: 25,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }

  void showDeleteConfirmationDialog(
      BuildContext context, Realm realm, HabitModel habit) {
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
              onPressed: () async {
                final habitUuid =
                    habit.habitUuid; // Assuming habit is available
                final habitToDelete =
                    realm.query<HabitModel>('habitUuid == "$habitUuid"').first;
                if (habitToDelete != null) {
                  print(
                      "Habit found: ${habitToDelete.name} (${habitToDelete.habitUuid})");
                  realm.write(() {
                    // Delete the habit from Realm
                    realm.delete(habitToDelete);
                  });
                  setState(() {
                    activeHabits.remove(habitToDelete);
                  });
                }
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  bool isStreakContinued(HabitModel habit) {
    final DateTime currentDate = DateTime.now();
    final List<DateTime> completionDates = [];

    // Get the last two completion dates
    for (var completedHabit in completedHabits.reversed) {
      completionDates.add(DateTime.parse(completedHabit.completionDate));
      if (completionDates.length == 2) break;
    }

    // Check if there's a completion for the last two consecutive days
    if (completionDates.length == 2) {
      final DateTime lastCompletionDate = completionDates[0];
      final DateTime secondLastCompletionDate = completionDates[1];

      // If there's no completion for the past two days, reset streak to 0
      if (currentDate.difference(lastCompletionDate).inDays > 1 ||
          lastCompletionDate.difference(secondLastCompletionDate).inDays > 1) {
        return false; // Streak is broken
      }

      // If the difference between the current date and the last completion date is 1 day,
      // and the difference between the last completion date and the second last completion date is 1 day,
      // then the streak is continued
      if (currentDate.difference(lastCompletionDate).inDays == 1 &&
          lastCompletionDate.difference(secondLastCompletionDate).inDays == 1) {
        return true;
      }
    }

    // If there's no completion for the last two consecutive days or streak is broken,
    // return false
    streak = 0;
    return false;
  }
}
