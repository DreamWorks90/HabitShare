import 'package:HabitShare/Realm/user/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:realm/realm.dart'; // Import the Realm package
import 'package:HabitShare/Realm/habit.dart';

Future<void> pushUserToMongoDB() async {
  // Initialize Realm
  final config = Configuration.local([UserModel.schema]);
  final realm = Realm(config);

  // Retrieve user details from Realm
  final users = realm.all<UserModel>();

  // Connect to MongoDB
  final db = await Db.create(
      'mongodb+srv://HabitShare:habitshare@cluster0.3yp4ekk.mongodb.net/HabitShare?retryWrites=true&w=majority');
  // 'mongodb://localhost:27017/HabitShare');
  await db.open();
  print('Connected to MongoDB');
  // Convert Iterable to List<Map<String, dynamic>>
  final userList = users.map((user) {
    return {
      '_id': user.id.hexString, // Assuming _id is ObjectId
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };
  }).toList();
  // Check for duplicate emails in MongoDB
  for (final user in userList) {
    final existingUser =
        await db.collection('UserModel').findOne({'email': user['email']});
    if (existingUser == null) {
      // Insert user details into MongoDB only if email doesn't exist
      await db.collection('UserModel').insert(user);
    }
  }
  print('User details inserted into MongoDB');
  // Close connections
  realm.close();
  await db.close();
  print('Connections closed');
}

Future<void> pushHabitsToMongoDB() async {
  // Initialize Realm
  final config = Configuration.local([HabitModel.schema]);
  final realm = Realm(config);

  // Retrieve habit details from Realm
  final habits = realm.all<HabitModel>();

  // Connect to MongoDB
  final db = await Db.create(
      'mongodb+srv://HabitShare:habitshare@cluster0.3yp4ekk.mongodb.net/HabitShare?retryWrites=true&w=majority');
  await db.open();
  print('Connected to MongoDB');

  // Convert Iterable to List<Map<String, dynamic>>
  final habitList = habits.map((habit) {
    return {
      '_id': habit.id.hexString, // Assuming _id is ObjectId
      'habitUuid': habit.habitUuid,
      'habitLink': habit.habitLink,
      'name': habit.name,
      'description': habit.description,
      'habitType': habit.habitType,
      'frequency': habit.frequency,
      'time': habit.time,
      'startDate': habit.startDate,
      'termDate': habit.termDate,
    };
  }).toList();

  // Check for duplicate habits in MongoDB (You may need to adjust this based on your actual data structure)
  for (final habit in habitList) {
    final existingHabit = await db.collection('HabitModel').findOne({
      'habitUuid': habit['habitUuid'],
    });

    if (existingHabit == null) {
      // Insert habit details into MongoDB only if the habit doesn't exist
      await db.collection('HabitModel').insert(habit);
    }
  }

  print('Habit details inserted into MongoDB');

  // Close connections
  realm.close();
  await db.close();
  print('Connections closed');
}

Future<void> syncLocalDatabaseWithMongoDB() async {
  final config = Configuration.local([UserModel.schema, HabitModel.schema]);
  final realm = Realm(config);

  try {
    print('Checking if local Realm database is empty...');
    // Check if the local Realm database is empty
    if (realm.all<UserModel>().isEmpty && realm.all<HabitModel>().isEmpty) {
      print(
          'Local Realm database is empty. Fetching and inserting data from MongoDB...');
      // Fetch and insert user data from MongoDB
      await pushUserToMongoDB();

      // Fetch and insert habits data from MongoDB
      await pushHabitsToMongoDB();
      print('Data successfully synced from MongoDB to local Realm database.');
    } else {
      print('Local Realm database is not empty. No need to sync.');
    }
  } catch (error, stackTrace) {
    print('Error syncing with MongoDB: $error');
    print('Stack trace: $stackTrace');
  } finally {
    // Close Realm connection
    realm.close();
  }
}
