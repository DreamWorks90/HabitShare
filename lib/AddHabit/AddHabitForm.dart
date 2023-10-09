import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../Constants/Constants.dart';
import '../HabitStatus/HabitStatus.dart';
import '../Model/DBUser.dart';
import '../Reducer/AppState.dart';
import '../Service/UserService.dart';
import 'Habit.dart';

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
  var _userService = UserService();
  String? selectedHabitType;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Build Habit'),
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HabitStatus()));
                },
                icon: Icon(Icons.arrow_back_outlined)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedStartDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedStartDate != null &&
                              pickedStartDate != startDate) {
                            setState(() {
                              startDate = pickedStartDate;
                            });
                          }
                        },
                        child: Text('Pick Start Date'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedEndDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (pickedEndDate != null &&
                              pickedEndDate != endDate) {
                            setState(() {
                              endDate = pickedEndDate;
                            });
                          }
                        },
                        child: Text('Pick End Date'),
                      ),
                    ),
                  ],
                ),
                AnimatedButtonBar(
                  radius: 32.0,
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  elevation: 24,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  innerVerticalPadding: 16,
                  children: [
                    ButtonBarEntry(
                      onTap: () {
                        setState(() {
                          selectedHabitType = 'Build';
                        });
                      },
                      child: Text(
                        'BUILD',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    ButtonBarEntry(
                      onTap: () {
                        setState(() {
                          selectedHabitType = 'Quit';
                        });
                      },
                      child: Text(
                        'Quilt',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                if (selectedHabitType != null)
                  Text(
                    'Selected Habit Type: $selectedHabitType',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xff1855f4),
                        fontWeight: FontWeight.bold),
                    hintText: 'ex: Walking',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Habit Description',
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xff1855f4),
                        fontWeight: FontWeight.bold),
                    hintText: ' need',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
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
                        color: Color(0xff1855f4),
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
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
                        color: Color(0xff1855f4),
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedFrequency != null &&
                        selectedTime != null &&
                        nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedHabitType != null &&
                        startDate != null &&
                        endDate != null) {
                      final habit = Habit(
                        name: nameController.text,
                        description: descriptionController.text,
                        frequency: selectedFrequency!,
                        time: selectedTime!,
                        startDate: startDate!,
                        endDate: endDate!,
                      );
                      habit.habitType = selectedHabitType;
                      StoreProvider.of<AppState>(context).dispatch(
                        AddHabitAction(habit),
                      );
                      StoreProvider.of<AppState>(context)
                          .dispatch(SetStartDateAction(startDate!));
                      StoreProvider.of<AppState>(context)
                          .dispatch(SetEndDateAction(endDate!));

                      nameController.clear();
                      descriptionController.clear();
                      setState(() {
                        selectedFrequency = null;
                        selectedTime = null;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HabitStatus()));

                      var _user = User();
                      _user.name = nameController.text;
                      _user.description = descriptionController.text;
                      _user.frequency = (selectedFrequency != null) as String?;
                      _user.time = (selectedTime != null) as String?;
                      var result = await _userService.SaveUser(_user);
                      print(result);
                    }
                  },
                  child: const Text('Add Habit'),
                ),
              ],
            ),
          ),
        ));
  }
}
