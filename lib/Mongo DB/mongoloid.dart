import 'package:HabitShare/Realm/invitation.dart';
import 'package:HabitShare/Realm/user/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:realm/realm.dart';
import 'package:HabitShare/Realm/habit.dart';

class MongoDBService {
  late final Db db;
  bool _isDatabaseOpened = false;
  List<Map<String, dynamic>> usersFromMongo = [];
  MongoDBService() {
    initDatabase();
  }
  Future<void> initDatabase() async {
    db = await Db.create('mongodb+srv://HabitShare:habitshare@cluster0.3yp4ekk.mongodb.net/HabitShare?retryWrites=true&w=majority');

    await db.open();
    print('Connected to MongoDB');
    _isDatabaseOpened = true;
  }

  Future<void> closeDatabase() async {
    try {
      await db.close();
      print('Disconnected from MongoDB');
    } catch (e) {
      print('Error closing database: $e');
    }
  }

  Future<List<Map<String, dynamic>>> retrieveUsersFromMongoDB() async {
    try {
      final userCollection = db.collection('UserModel');
      usersFromMongo = await userCollection.find().toList();
      print('Retrieved ${usersFromMongo.length} users from MongoDB');
      return usersFromMongo;
    } catch (e, stackTrace) {
      print('Error retrieving users from MongoDB: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }
}


final config = Configuration.local([UserModel.schema]);
final realm = Realm(config);
Future<void> pushUserToMongoDB(Db db) async {
  // Retrieve user details from Realm
  final users = realm.all<UserModel>();
  final userList = users.map((user) {
    return {
      '_id': user.id.hexString, // Assuming _id is ObjectId
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'contactNumber': user.contactNumber,
      'loggedIn': user.loggedIn,
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

}

Future<void> pushInvitationToMongoDB(Db db) async {
  final config = Configuration.local([InvitationModel.schema]);
  final realm = Realm(config);
  // Retrieve Invitation details from Realm
  final invitations = realm.all<InvitationModel>();
  final invitationList = invitations.map((invitation) {
    return {
      '_id': invitation.id.hexString, // Assuming _id is ObjectId
      'inviterId': invitation.inviterId,
      'inviteeId': invitation.inviteeId,
      'inviteeContactNumber': invitation.inviteeContactNumber,
      'status': invitation.status,
    };
  }).toList();
  // Check for duplicate invitation in MongoDB
  for (final invitation in invitationList) {
    final existingInvitation =
    await db.collection('InvitationModel').findOne({'inviteeContactNumber': invitation['inviteeContactNumber']});
    if (existingInvitation == null) {
      // Insert invitation details into MongoDB only if email doesn't exist
      await db.collection('InvitationModel').insert(invitation);
    }
  }
}


Future<void> pushHabitsToMongoDB(Db db) async {
  // Retrieve habit details from Realm
  final habits = realm.all<HabitModel>();
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
}

/*Future<void> syncLocalDatabaseWithMongoDB() async {
  final db = await Db.create('mongodb+srv://HabitShare:habitshare@cluster0.3yp4ekk.mongodb.net/HabitShare?retryWrites=true&w=majority');
  await db.open();
  try {
    if (realm.all<UserModel>().isEmpty && realm.all<HabitModel>().isEmpty) {
      await pushUserToMongoDB(db);
      await pushHabitsToMongoDB(db);
      print('Data successfully synced from MongoDB to local Realm database.');
    } else {
      print('Local Realm database is not empty. No need to sync.');
    }
  } catch (error, stackTrace) {
    print('Error syncing with MongoDB: $error');
    print('Stack trace: $stackTrace');
  } finally {
    await db.close();
  }
}*/
