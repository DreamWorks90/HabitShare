import 'package:HabitShare/Realm/habit.dart';
import 'package:HabitShare/features/habits/models/HabitModel.dart';
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

class EditHabitForm extends StatefulWidget {
  final HabitModel habit;
  final Function  refreshHabitList;
  const EditHabitForm({Key? key, required this.habit, required this.refreshHabitList}) : super(key: key);
  @override
  _EditHabitFormState createState() => _EditHabitFormState();
}

class _EditHabitFormState extends State<EditHabitForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  HabitFrequency? selectedFrequency;
  HabitTime? selectedTime;
  String? selectedHabitType;
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? termDate;
  TimeOfDay? selectedTimeOfDay;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and selected values with habit details
    nameController = TextEditingController(text: widget.habit.name);
    descriptionController = TextEditingController(text: widget.habit.description);
    selectedFrequency = HabitFrequency.values
        .firstWhere((element) => element.toString() == widget.habit.frequency);
    selectedTime = HabitTime.custom; // Set according to your habit model
    selectedTimeOfDay = habitTimeFromString(widget.habit.time);
    selectedDate = DateTime.parse(widget.habit.startDate);
    termDate = DateTime.parse(widget.habit.termDate ?? DateTime.now().toString());
    if (selectedTimeOfDay != null) {
      selectedTime = HabitTime.custom; // Update your selectedTime accordingly
    }
  }
  void _updateSelectedTime(TimeOfDay? newTime) {
    if (newTime != null) {
      setState(() {
        selectedTimeOfDay = newTime;
      });
    }
  }

  TimeOfDay? habitTimeFromString(String? habitTimeString) {
    if (habitTimeString == null || habitTimeString.isEmpty) {
      return null;
    }
    List<String> timeParts = habitTimeString.split(':');
    if (timeParts.length == 2) {
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      return TimeOfDay(hour: hours, minute: minutes);
    }
    return null;
  }
  Future<void> showTimePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showRoundedTimePicker(
      context: context,
      initialTime: selectedTimeOfDay ?? TimeOfDay.now(),
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
    _updateSelectedTime(pickedTime);
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
      });
    }
  }

  Future<void> _selectTermDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: termDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        termDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Edit Habit',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
              ),            TextFormField(
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
                    selectedFrequency = value!;
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
                  absorbing: true,
                  child: TextFormField(
                    controller: TextEditingController(
                      text: selectedTimeOfDay != null
                          ? selectedTimeOfDay!.format(context)
                          : '',
                    ),
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
                controller: TextEditingController( text: selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                    : '',
                ),
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
                controller: TextEditingController(text: termDate != null
                    ? DateFormat('dd/MM/yyyy').format(termDate!)
                    : '',
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                    final config = Configuration.local([HabitModel.schema]);
                    final realm = Realm(config);
                    // Start a write transaction
                    realm.write(() {
                      final habits = realm.all<HabitModel>();
                      final habitToUpdate = habits.firstWhere(
                            (h) => h.id.hexString == widget.habit.id.hexString,
                        orElse: () => throw Exception('Habit not found'),
                      );
                      // Update the habit properties
                      habitToUpdate.name = nameController.text;
                      habitToUpdate.description = descriptionController.text;
                      habitToUpdate.frequency = selectedFrequency.toString();
                      habitToUpdate.time = selectedTime.toString();
                      habitToUpdate.startDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
                      habitToUpdate.termDate = DateFormat('yyyy-MM-dd').format(termDate!);
                      habitToUpdate.habitType = selectedHabitType ?? habitToUpdate.habitType;
                    });
                    realm.close();
                    widget.refreshHabitList();
                    Navigator.pop(context); // Close the edit form
                },
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
