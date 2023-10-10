import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/tabs/HabitShareTabs.dart';
import 'package:HabitShare/redux/AppState.dart';
import '../models/Habit.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Build Habit'),
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
                  borderWidth: 0.25,
                  innerVerticalPadding: 16,
                  children: [
                    ButtonBarEntry(
                      onTap: () {
                        setState(() {
                          selectedHabitType = 'Build';
                        });
                      },
                      child: const Text(
                        'BUILD',
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
                        'Quilt',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                if (selectedHabitType != null)
                  const SizedBox(
                    height: 20,
                  ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Name',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    hintText: 'ex: Walking',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Description',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
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
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
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
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
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
                          time: selectedTime!);
                      habit.habitType = selectedHabitType;

                      StoreProvider.of<AppState>(context).dispatch(
                        AddHabitAction(habit),
                      );

                      nameController.clear();
                      descriptionController.clear();
                      setState(() {
                        selectedFrequency = null;
                        selectedTime = null;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HabitStatus(),
                        ),
                      );
                    } else {
                      _showNoHabitTypeAlert(context);
                    }
                  },
                  child: const Text(
                    'Add Habit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void _showNoHabitTypeAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text(
          'Please select a habit type (BUILD or QUIT) before adding the habit.',
        ),
        actions: <Widget>[
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
