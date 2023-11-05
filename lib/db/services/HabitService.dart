import 'package:sqflite/sqflite.dart';
import 'package:HabitShare/db/models/Habit.dart';
import 'package:HabitShare/db/models/User.dart';
import 'package:HabitShare/db/models/Friend.dart';
import 'package:HabitShare/db/DBHelper.dart';

class HabitService {

  final DBHelper _dbHelper = DBHelper();

  // Define a function that inserts User into the database
  Future<void> insertHabit(Habit habit) async {
    final db = await _dbHelper.database;

    int habit_id = await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> retrieveHabitsOfUser(User user) async {
    final db = await _dbHelper.database;

    int? userId = user.user_id;
    List<Map<String, Object?>> habits = await db.rawQuery('SELECT * FROM habits WHERE user_id=?', [userId]);
    return habits;
  }

  Future<List<Map<String, Object?>>> retrieveHabitsOfFriend(Friend friend) async {
    final db = await _dbHelper.database;

    int? friendId = friend?.friend_id;
    List<Map<String, Object?>> habits = await db.rawQuery('SELECT * FROM habits WHERE friend=?', [friendId]);
    return habits;
  }
}