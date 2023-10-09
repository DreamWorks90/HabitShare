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
  final DateTime startDate;
  final DateTime endDate;
  Set<DateTime> completedDates;

  Habit({
    required this.name,
    required this.description,
    required this.frequency,
    required this.time,
    this.habitType,
    required this.startDate,
    required this.endDate,
    Set<DateTime>? completedDates,
  }) : completedDates = completedDates ?? {};

  void markAsCompleted(DateTime date) {
    completedDates.add(date);
  }
}
