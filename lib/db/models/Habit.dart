class Habit {
  final int? habit_id;
  final String habitUuid;
  final String name;
  final int type;
  final int frequency;
  final String? description;
  final String time;
  final String start_date;
  final String? end_date;
  final int user_id;
  final int? friend_id;
  final String habitLink;

  Habit({
    required this.habit_id,
    required this.habitUuid,
    required this.name,
    required this.type,
    required this.frequency,
    this.description,
    required this.time,
    required this.start_date,
    this.end_date,
    required this.user_id,
    this.friend_id,
    required this.habitLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'habit_id': habit_id,
      'habitUuid': habitUuid,
      'name': name,
      'type': type,
      'frequency': frequency,
      'description': description,
      'time': time,
      'start_date': start_date,
      'end_date': end_date,
      'user_id': user_id,
      'friend_id': friend_id,
      'habitLink': habitLink,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
        habit_id: map['habit_id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        type: map['type'] ?? '',
        frequency: map['frequency'] ?? '',
        description: map['description'] ?? '',
        time: map['time'] ?? '',
        start_date: map['start_date'] ?? '',
        end_date: map['end_date'] ?? '',
        user_id: map['user_id'] ?? '',
        friend_id: map['friend_id'] ?? '',
        habitUuid: '',
        habitLink: '');
  }
}
