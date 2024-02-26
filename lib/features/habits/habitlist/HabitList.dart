import 'dart:async';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/Realm/habit.dart';
import 'package:HabitShare/features/habits/EditHabit/edit_habit_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../friends/addfriends/current_user_provider.dart';
import '../../notification/notification.dart';
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
  int _currentSegment = 0; // Added to keep track of the selected segment
  bool hasNotifications = false;
  bool isNotificationPopoverVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeRealm();
      }
  void togglePopover() {
    setState(() {
      isNotificationPopoverVisible = !isNotificationPopoverVisible;
    });
  }


  void _refreshHabitList() {
    setState(() {
      // Fetch and update habits from the realm
      final habits = realm.all<HabitModel>();
      activeHabits = habits.where((habit) => !habit.isCompletedToday).toList();
      completedHabits = habits.where((habit) => habit.isCompletedToday).toList();
    });
  }

  Future<void> _initializeRealm() async {
    try {
      final config = Configuration.local([HabitModel.schema]); // Customize Realm configuration here
      realm = await Realm.open(config);
      setState(() {
        isRealmInitialized = true;
      });
    } catch (e) {
      print('Error initializing Realm: $e');
    }// Trigger a rebuild after Realm is initialized
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
    }
    else
    {
      final habits = realm.all<HabitModel>();
      activeHabits = habits.where((habit) => !habit.isCompletedToday).toList();
      completedHabits = habits.where((habit) => habit.isCompletedToday).toList();
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
        }
        else if (completedHabit.frequency == 'HabitFrequency.weekly') {
          final startDate = DateTime.parse(completedHabit.startDate);
          final termDate = DateTime.parse(completedHabit.termDate);
          DateTime nextOccurrence = startDate.add(const Duration(days: 7));
          while (nextOccurrence.isBefore(termDate)|| isSameDay(nextOccurrence, termDate)) {
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
        }
        else if (completedHabit.frequency == 'HabitFrequency.weekend') {
          if (((currentDate.weekday == DateTime.sunday)||(currentDate.weekday == DateTime.saturday))&&
    !isSameDay(currentDate, completionDate)) {
            // Update isCompletedToday to false for Sunday
            realm.write(() {
              completedHabit.isCompletedToday = false;
            });// Move habit from active to completed list
            setState(() {
              activeHabits.add(completedHabit);
            });
          }
        }
        }
      final notificationProvider = Provider.of<NotificationProvider>(context);
      final notifications = notificationProvider.notifications;

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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: hasNotifications ? Colors.red : null,
              ),
              onPressed: togglePopover,
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationList()));*/

            ),

          ],

        ),
        body: isNotificationPopoverVisible?Stack(
          children: [Center(
        child: Container(
        //margin: EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 550), // Set max height here
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            // Handle accept action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // Handle reject action
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    ]
    )
        :SizedBox(
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
                        final startDate =
                        DateTime.parse(habit.startDate);
                        final termDate =
                        DateTime.parse(habit.termDate);
                        int totalDays = calculateTotalDays(habit);
                        double completionPercentage = calculateCompletionPercentage(habit);
                        if (habit.frequency == 'HabitFrequency.daily') {
                          shouldDisplay = selectedDate.isAfter(startDate) &&
                              (selectedDate.isBefore(termDate) || isSameDay(selectedDate, termDate));
                        } else if (habit.frequency == 'HabitFrequency.weekend') {
                          shouldDisplay = (selectedDate.weekday == DateTime.saturday ||
                              selectedDate.weekday == DateTime.sunday) &&
                              selectedDate.isAfter(startDate) &&
                              (selectedDate.isBefore(termDate) || isSameDay(selectedDate, termDate));
                        } else if (habit.frequency == 'HabitFrequency.weekly') {
                          DateTime nextOccurrence = startDate;
                          while (nextOccurrence.isBefore(termDate)) {
                            if (nextOccurrence.isAfter(selectedDate)) {
                              break;
                            }
                            if (isSameDay(nextOccurrence, selectedDate)) {
                              shouldDisplay = true;
                              break;
                            }
                            nextOccurrence = nextOccurrence.add(const Duration(days: 7));
                          }
                          shouldDisplay = shouldDisplay &&
                              (selectedDate.isBefore(termDate) || isSameDay(selectedDate, termDate));
                        }
                        if (shouldDisplay) {
                          final String percentage =
                              '%: ${completionPercentage.toStringAsFixed(2)}%';
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showHabitDetailsDialog(context, habit);
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
                                                  child: const Text('Yes'),
                                                  onPressed: () async {
                                                    realm.write(() {
                                                      habit.isCompletedToday = true;
                                                      if (habit.termDate != null) {
                                                        // Check if termDate is available
                                                        final DateTime currentDate = DateTime.now();
                                                        final DateTime termDate = DateTime.parse(habit.termDate!);
                                                        // If the current date is before or equal to the term date, increment totalCompletedDays
                                                        if (currentDate.isBefore(termDate) || currentDate.isAtSameMomentAs(termDate)) {
                                                          habit.totalCompletedDays += 1;
                                                        }
                                                      } else {
                                                        // If termDate is null, always increment totalCompletedDays
                                                        habit.totalCompletedDays += 1;
                                                      }
                                                      // Update completionDate with the current date
                                                      habit.completionDate = DateTime.now().toString();
                                                    });
                                                    // Move habit from active to completed list
                                                    setState(() {
                                                      activeHabits.remove(selectedHabit);
                                                      completedHabits.add(selectedHabit!);
                                                    });
                                                    // Update habit in Realm (if needed)
                                                    Navigator.of(dialogContext).pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
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
                                                    Expanded(
                                                      child: SvgPicture.asset(
                                                        'assets/images/streak.svg',
                                                        height: 20,
                                                      ),
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
                                                      width: 5,
                                                    ),
                                                    Expanded(
                                                      child: SvgPicture.asset(
                                                        'assets/images/calendar.svg',
                                                        height: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      '  ${habit.frequency.toString().split('.').last}',
                                                      style:
                                                      const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/images/streak.svg',
                                                      height: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                     Text(
                                                       percentage,
                                                      style: const TextStyle(
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
                                                if (value == 'delete') {
                                                  showDeleteConfirmationDialog(
                                                      context,realm, habit);
                                                } else if (value ==
                                                    'edit') {

                                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>EditHabitForm(habit: habit,refreshHabitList: _refreshHabitList,)));
                                                } else if (value ==
                                                    'shareFriends') {
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
                                  ),
                                ],
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
  void showDeleteConfirmationDialog(BuildContext context,Realm realm,HabitModel habit) {
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
                final habitUuid = habit.habitUuid; // Assuming habit is available
                final habitToDelete = realm.query<HabitModel>('habitUuid == "$habitUuid"').first;
                if (habitToDelete != null) {
                  print("Habit found: ${habitToDelete.name} (${habitToDelete.habitUuid})");
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
}







