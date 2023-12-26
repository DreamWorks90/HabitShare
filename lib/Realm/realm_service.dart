/*import 'package:realm/realm.dart';
import 'package:HabitShare/Realm/habit.dart';

class RealmService {
  late Realm _realm;
  late Configuration _config;

  RealmService() {
    _config = Configuration.local([Habit.schema]);
    _realm = Realm(_config);
  }

  // Add a new Habit to the Realm.
  Future<void> addHabit(Habit habit) async {
    _realm.write(() {
      _realm.add(habit);
    });
  }

  // Retrieve all Habit objects in the Realm.
  RealmResults<Habit> getAllHabits() {
    final habits = _realm.all<Habit>();
    return habits;
  }

  // Update a Habit in the Realm.
  Future<void> updateHabit(Habit habit) async {
    _realm.write(() {
      _realm.add(habit, update: true);
    });
  }

  // Delete a Habit from the Realm.
  Future<void> deleteHabit(Habit habit) async {
    _realm.write(() {
      _realm.delete(habit);
    });
  }

// Additional CRUD operations can be added based on your requirements
}*/
