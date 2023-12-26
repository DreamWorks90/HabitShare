import 'package:HabitShare/Realm/user/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:realm/realm.dart'; // Import the Realm package

void pushToMongoDB() async {
  // Initialize Realm
  final config = Configuration.local([UserModel.schema]);
  final realm = Realm(config);

  // Retrieve user details from Realm
  final users = realm.all<UserModel>();

  // Connect to MongoDB
  final db = await Db.create(
      'mongodb+srv://HabitShare:habitshare@cluster0.3yp4ekk.mongodb.net/HabitShare?retryWrites=true&w=majority');
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
