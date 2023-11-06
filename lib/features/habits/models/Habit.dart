enum HabitFrequency {
  daily,
  weekly,
  weekend,
}

enum HabitTime {
  morning,
  evening,
  night,
}

class Habit {
  final String name;
  final String description;
  final HabitFrequency frequency;
  final HabitTime time;
  String? habitType;
  final String startDate; // Assuming date is stored as a String in your class
  final String termDate; // Assuming date is stored as a String in your class
  String?
      completionDate; // Date when the habit was completed (null if not completed)

  Habit({
    required this.name,
    required this.description,
    required this.frequency,
    required this.time,
    this.habitType,
    required this.startDate,
    required this.termDate,
    this.completionDate,
  });
}
