enum HabitFrequency {
  daily,
  weekly,
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

  Habit({
    required this.name,
    required this.description,
    required this.frequency,
    required this.time,
    this.habitType,
  });
}