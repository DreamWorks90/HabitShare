import 'package:flutter/material.dart';

enum HabitFrequency {
  daily,
  weekly,
  weekend,
}

enum HabitTime { morning, afternoon, evening, night, custom }

class HabitModel {
  final String habitUuid;
  final String name;
  final String description;
  final HabitFrequency frequency;
  final TimeOfDay time;
  String? habitType;
  final String notificationMessage;
  final String startDate; // Assuming date is stored as a String in your class
  final String termDate; // Assuming date is stored as a String in your class
  String?
      completionDate; // Date when the habit was completed (null if not completed)

  HabitModel(
      {required this.name,
      required this.description,
      required this.frequency,
      required this.time,
      this.habitType,
      required this.startDate,
      required this.termDate,
      required this.notificationMessage,
      this.completionDate,
      required this.habitUuid});
}
