import 'package:sqflite/sqflite.dart';
import 'package:HabitShare/db/models/Friend.dart';
import 'package:HabitShare/db/models/User.dart';
import 'package:HabitShare/db/DBHelper.dart';

class FriendService {

  final DBHelper _dbHelper = DBHelper();

  // Define a function that inserts User into the database
  Future<void> insertFriend(Friend friend) async {
    final db = await _dbHelper.database;

    int friend_id = await db.insert(
      'friends',
      friend.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, Object?>>> retrieveFriendsOfUser(User user) async {
    final db = await _dbHelper.database;

    int? user_id = user.user_id;
    List<Map<String, Object?>> friends = await db.rawQuery('SELECT * FROM friends WHERE user_id=?', [user_id]);
    return friends;
  }

}