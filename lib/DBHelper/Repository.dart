import 'package:habitshare_dw/DBHelper/DataBaseConnection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  get itemId => null;

  //insert User
  insertData(user, data) async {
    var connection = await database;
    return await connection?.insert(user, data);
  }

  //read all record
  readData(user) async {
    var connection = await database;
    return await connection?.query(user);
  }

  //read single record bt id

  readDataById(user, itemId) async {
    var connection = await database;
    return await connection?.query(user, where: 'id=?', whereArgs: [itemId]);
  }

  //update User

  updateData(user, data) async {
    var connection = await database;
    return await connection
        ?.update(user, data, where: 'id=?', whereArgs: [data['id]']]);
  }

  //delete user
  deleteDataById(user, ItemId) async {
    var connection = await database;
    return await connection?.rawDelete('delete from $user where id=$itemId');
  }
}
