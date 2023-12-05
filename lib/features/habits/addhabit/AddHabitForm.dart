import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../redux/AppState.dart';
import '../models/HabitModel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:HabitShare/db/services/HabitService.dart';
import 'package:HabitShare/db/services/UserService.dart';
import 'package:HabitShare/db/models/Habit.dart';
import 'package:HabitShare/db/models/User.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

class AddHabitForm extends StatefulWidget {
  const AddHabitForm({Key? key}) : super(key: key);

  @override
  _AddHabitFormState createState() => _AddHabitFormState();
}

class _AddHabitFormState extends State<AddHabitForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  HabitFrequency? selectedFrequency;
  HabitTime? selectedTime;
  String? selectedHabitType;
  DateTime? selectedDate;
  String? startDate;
  String? termDate;
  Map<String, dynamic>? selectedFriend;
  TimeOfDay? selectedTimeOfDay;
  String habitUuid = const Uuid().v4();

  HabitService habitService = HabitService();
  UserService userService = UserService();

  Future<void> _onSaveHabit(String name, int type, int frequency,
      String description, String startDate, String time) async {
    List<Map<String, Object?>> users = await userService.retrieveLoggedInUser();
    Map<String, Object?> userResult = users.first;
    User loggedInUser = User.fromMap(userResult);

    Habit habit = Habit(
        habitUuid: habitUuid, // Store the generated UUID in the habit model
        name: name,
        type: 0,
        frequency: frequency,
        description: description,
        time: time,
        start_date: startDate,
        user_id: loggedInUser.user_id!,
        habit_id: null);

    await habitService.insertHabit(habit);
  }

  Future<void> showTimePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showRoundedTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      style: MaterialRoundedDatePickerStyle(
        textStyleButtonPositive: const TextStyle(color: Colors.black),
        textStyleButtonNegative: const TextStyle(color: Colors.black),
        textStyleYearButton: const TextStyle(color: Colors.black),
        textStyleDayHeader: const TextStyle(color: Colors.black),
        textStyleDayOnCalendar: const TextStyle(color: Colors.black),
        textStyleDayOnCalendarSelected: const TextStyle(color: Colors.white),
        textStyleCurrentDayOnCalendar: const TextStyle(color: Colors.black),
        textStyleDayOnCalendarDisabled: const TextStyle(color: Colors.grey),
        textStyleMonthYearHeader: const TextStyle(color: Colors.black),
      ),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTimeOfDay = pickedTime;
        selectedTime = HabitTime.custom; // Update your selectedTime accordingly
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        startDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  Future<void> _selectTermDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: termDate != null
          ? DateTime.parse(termDate!)
          : startDate != null
              ? DateTime.parse(startDate!)
              : DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        termDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Add Habit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HabitStatus()));
            },
            icon: const Icon(Icons.arrow_back_outlined)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AnimatedButtonBar(
              radius: 32.0,
              padding: const EdgeInsets.all(16.0),
              backgroundColor: Colors.grey,
              foregroundColor: primaryColor,
              elevation: 24,
              borderColor: Colors.white,
              borderWidth: 0.15,
              innerVerticalPadding: 16,
              children: [
                ButtonBarEntry(
                  onTap: () {
                    setState(() {
                      selectedHabitType = 'Build';
                    });
                  },
                  child: const Text(
                    'Build',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                ButtonBarEntry(
                  onTap: () {
                    setState(() {
                      selectedHabitType = 'Quit';
                    });
                  },
                  child: const Text(
                    'Quit',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                labelStyle:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                hintText: 'ex: Walking',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLines: 3,
              keyboardType: TextInputType.text,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Habit Description',
                labelStyle:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                hintText: ' need',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<HabitFrequency>(
              value: selectedFrequency,
              onChanged: (value) {
                setState(() {
                  selectedFrequency = value;
                });
              },
              items: HabitFrequency.values.map((frequency) {
                return DropdownMenuItem<HabitFrequency>(
                  value: frequency,
                  child: Text(frequency.toString().split('.').last),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Frequency',
                labelStyle:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showTimePicker(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                      text: selectedTimeOfDay?.format(context) ?? ''),
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: TextEditingController(text: startDate),
              decoration: InputDecoration(
                labelText: 'Start Date',
                labelStyle: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: TextEditingController(text: termDate ?? ''),
              decoration: InputDecoration(
                labelText: 'Term Date',
                labelStyle: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _selectTermDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                if (selectedFrequency != null &&
                    nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    selectedHabitType != null &&
                    startDate != null &&
                    termDate != null) {
                  final habitModel = HabitModel(
                    habitUuid: habitUuid,
                    name: nameController.text,
                    description: descriptionController.text,
                    frequency: selectedFrequency!,
                    time: selectedTimeOfDay!,
                    startDate: startDate!,
                    termDate: termDate!,
                    notificationMessage: '',
                  );

                  habitModel.habitType = selectedHabitType;
                  //habit.sharedWith = selectedFriend;
                  final notificationTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTimeOfDay!.hour - 1,
                      selectedTimeOfDay!.minute);

                  StoreProvider.of<AppState>(context).dispatch(
                    AddHabitAction(
                      habitModel,
                    ),
                  );

                  DateTime? tempStartDate = DateTime.tryParse(startDate!);
                  var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
                  String formattedStartDate = formatter.format(tempStartDate!);
                  String formattedTime = formatter.format(notificationTime!);

                  _onSaveHabit(
                      nameController.text,
                      0,
                      selectedFrequency!.index,
                      descriptionController.text,
                      formattedTime,
                      formattedStartDate);

                  nameController.clear();
                  descriptionController.clear();
                  setState(() {
                    selectedFrequency = null;
                    selectedTime = null;
                    startDate = null;
                    termDate = null;
                  });
                  if (selectedHabitType == null) {
                    print("please select habit type");
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HabitStatus()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Validation Error'),
                        content: const Text(
                            'Please make sure to fill in all the required fields and select Build/Quit before proceeding.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Add Habit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
