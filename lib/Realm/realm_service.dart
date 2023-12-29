import 'package:realm/realm.dart';
import 'package:HabitShare/Realm/habit.dart';

class RealmService {
  late Realm _realm;
  late Configuration _config;

  RealmService() {
    _config = Configuration.local([HabitModel.schema]);
    _realm = Realm(_config);
  }

  // Add a new Habit to the Realm.
  Future<void> addHabit(HabitModel habit) async {
    _realm.write(() {
      _realm.add(habit);
    });
  }

  // Retrieve all Habit objects in the Realm.
  RealmResults<HabitModel> getAllHabits() {
    final habits = _realm.all<HabitModel>();
    return habits;
  }

  // Update a Habit in the Realm.
  Future<void> updateHabit(HabitModel habit) async {
    _realm.write(() {
      _realm.add(habit, update: true);
    });
  }

  // Delete a Habit from the Realm.
  Future<void> deleteHabit(HabitModel habit) async {
    _realm.write(() {
      _realm.delete(habit);
    });
  }

// Additional CRUD operations can be added based on your requirements
}
