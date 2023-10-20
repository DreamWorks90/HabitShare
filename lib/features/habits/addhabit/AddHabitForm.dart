import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:HabitShare/redux/AppState.dart';
import '../models/Habit.dart';
import 'package:intl/intl.dart';

class AddHabitForm extends StatefulWidget {
  //AddHabitForm({Key? key, required this.isBuildHabit}) : super(key: key);
  const AddHabitForm({super.key});

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
  String? formattedDate;

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
        formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text(
              'Add Habit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HabitStatus()));
                },
                icon: const Icon(Icons.arrow_back_outlined)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
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
                // if (selectedHabitType != null)
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
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
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<HabitTime>(
                  value: selectedTime,
                  onChanged: (value) {
                    setState(() {
                      selectedTime = value;
                    });
                  },
                  items: HabitTime.values.map((time) {
                    return DropdownMenuItem<HabitTime>(
                      value: time,
                      child: Text(time.toString().split('.').last),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    labelStyle: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
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
                  controller: TextEditingController(text: formattedDate),
                  decoration: InputDecoration(
                    labelText: 'Term',
                    labelStyle: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    if (selectedFrequency != null &&
                        selectedTime != null &&
                        nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedHabitType != null) {
                      final habit = Habit(
                        name: nameController.text,
                        description: descriptionController.text,
                        frequency: selectedFrequency!,
                        time: selectedTime!,
                        date: formattedDate!,
                      );
                      habit.habitType = selectedHabitType;
                      print('Selected Date: $formattedDate');
                      StoreProvider.of<AppState>(context).dispatch(
                        AddHabitAction(habit),
                      );

                      nameController.clear();
                      descriptionController.clear();
                      setState(() {
                        selectedFrequency = null;
                        selectedTime = null;
                        formattedDate = null;
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
        ));
  }
}
