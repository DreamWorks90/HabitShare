import 'package:sqflite/sqflite.dart';
import 'package:HabitShare/db/models/User.dart';
import 'package:HabitShare/db/DBHelper.dart';


class UserService {
x
  final DBHelper _dbHelper = DBHelper();

  // Define a function that inserts User into the database
  Future<void> insertUser(User user) async {
    final db = await _dbHelper.database;

    int user_id = await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> retrieveUser(User user) async {
    final db = await _dbHelper.database;

    String email = user.email;
    List<Map<String, Object?>> users = await db.rawQuery('SELECT * FROM users WHERE email=?', [email]);
    return users;
  }

  Future<List<Map<String, Object?>>> retrieveLoggedInUser() async {
    final db = await _dbHelper.database;

    List<Map<String, Object?>> users = await db.rawQuery('SELECT * FROM users WHERE logged_in=1');
    return users;
  }

}