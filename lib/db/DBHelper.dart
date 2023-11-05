import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _dbHelper = DBHelper._internal();
  factory DBHelper() => _dbHelper;
  DBHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<bool> databaseExists(String path) =>
      databaseFactory.databaseExists(path);

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'habits_share_database.db');

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    const queryCreateUsersTable = '''
      CREATE TABLE users (
	      user_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	      name varchar NOT NULL,
	      email varchar NOT NULL UNIQUE,
	      password varchar NOT NULL,
	      logged_in BOOLEAN,
	      token_google varchar,
	      user_token varchar,
	      token_expiration DATETIME,
	      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
      );''';

    await db.execute(queryCreateUsersTable);

    const queryCreateFriendsTable = '''
      CREATE TABLE friends (
	      friend_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	      email varchar NOT NULL UNIQUE,
	      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
      );''';

    await db.execute(queryCreateFriendsTable);

    const queryCreateHabitsTable = '''
      CREATE TABLE habits (
	      habit_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	      name varchar NOT NULL,
	      type int NOT NULL,
	      frequency int NOT NULL,
	      time int NOT NULL,
	      description TEXT,
	      start_date TIMESTAMP,
	      end_date TIMESTAMP,
	      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	      user_id integer NOT NULL,
	      friend_id integer NOT NULL,	      
	      FOREIGN KEY (user_id) REFERENCES users (user_id),
	      FOREIGN KEY (friend_id) REFERENCES friends (friend_id)
      );''';

    await db.execute(queryCreateHabitsTable);
  }
}