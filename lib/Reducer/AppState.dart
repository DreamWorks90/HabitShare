import 'package:habitshare/AddHabit/Habit.dart';
import 'package:redux/redux.dart';

class AppState {
  final List<Habit> habits;
  final List<Habit> completedHabits;
  AppState({required this.habits, required this.completedHabits});
}

final List<Habit> initialHabits = [];

class AddHabitAction {
  final Habit habit;

  AddHabitAction(this.habit);
}

class RemoveHabitAction {
  final String habitName;

  RemoveHabitAction(this.habitName);
}

class AddCompletedHabitAction {
  final Habit habit;

  AddCompletedHabitAction(this.habit);
}

// Define an action to remove a completed habit
class RemoveCompletedHabitAction {
  final String habitName;

  RemoveCompletedHabitAction(this.habitName);
}

AppState appReducer(AppState state, dynamic action) {
  if (action is AddHabitAction) {
    return AppState(
      habits: List.from(state.habits)..add(action.habit),
      completedHabits: state.completedHabits,
    );
  } else if (action is RemoveHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name != action.habitName;
    }).toList();
    return AppState(
      habits: updatedHabits,
      completedHabits: state.completedHabits,
    );
  } else if (action is AddCompletedHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name !=
          action.habit.name; // Remove the habit with the same name
    }).toList();
    return AppState(
      habits: updatedHabits, // Don't modify habits
      completedHabits: List.from(state.completedHabits),
    );
  }
  return state;
}

final store = Store<AppState>(
  appReducer,
  initialState: AppState(
    habits: initialHabits,
    completedHabits: [],
  ),
);
