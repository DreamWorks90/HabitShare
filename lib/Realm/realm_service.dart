import 'package:realm/realm.dart';
import 'package:HabitShare/Realm/habit.dart';

class RealmService {
  late Realm realm;
  late Configuration config;

  RealmService() {
    config = Configuration.local([HabitModel.schema]);
    realm = Realm(config);
  }

  // Add a new Habit to the Realm.
  Future<void> addHabit(HabitModel habit) async {
    realm.write(() {
      realm.add(habit);
    });
  }

  // Retrieve all Habit objects in the Realm.
  RealmResults<HabitModel> getAllHabits() {
    final habits = realm.all<HabitModel>();
    return habits;
  }

  // Update a Habit in the Realm.
  Future<void> updateHabit(HabitModel habit) async {
    realm.write(() {
      realm.add(habit, update: true);
    });
  }

  // Delete a Habit from the Realm.
  Future<void> deleteHabit(HabitModel habit) async {
    realm.write(() {
      realm.delete(habit);
    });
  }

  Future<void> completedHabit(HabitModel habit) async {
    realm.write(() {
      realm.delete(habit);
    });
  }

// Additional CRUD operations can be added based on your requirements
}
