import 'package:add_habit_demo_3/app_state.dart';
import 'package:add_habit_demo_3/habit.dart';
import 'package:add_habit_demo_3/model/user.dart';
import 'package:add_habit_demo_3/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddHabitForm extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: <Widget>[
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
                  descriptionController.text.isNotEmpty) {
                final habit = Habit(
                  name: nameController.text,
                  description: descriptionController.text,
                  frequency: selectedFrequency!,
                  time: selectedTime!,
                );

                StoreProvider.of<AppState>(context).dispatch(
                  AddHabitAction(habit),
                );

                nameController.clear();
                descriptionController.clear();
                setState(() {
                  selectedFrequency = null;
                  selectedTime = null;
                });
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
    );
  }
}
