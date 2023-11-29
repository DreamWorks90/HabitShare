import 'package:sqflite/sqflite.dart';
import 'package:HabitShare/db/models/User.dart';
import 'package:HabitShare/db/DBHelper.dart';

class UserService {
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
    List<Map<String, Object?>> users =
        await db.rawQuery('SELECT * FROM users WHERE email=?', [email]);
    return users;
  }

  Future<List<Map<String, Object?>>> retrieveLoggedInUser() async {
    final db = await _dbHelper.database;

    List<Map<String, Object?>> users =
        await db.rawQuery('SELECT * FROM users WHERE logged_in=1');
    return users;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;

    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    } else {
      return null;
    }
  }

  Future<void> updateLoggedInStatus(String email, int newLoggedInValue) async {
    final db = await _dbHelper.database;

    // Update logged_in status for all users except the current sign-in user
    await db.update(
      'users',
      {'logged_in': 0},
      where: 'email != ?',
      whereArgs: [email],
    );

    // Update logged_in status for the current sign-in user
    await db.update(
      'users',
      {'logged_in': newLoggedInValue},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
