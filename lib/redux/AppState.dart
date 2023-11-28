import 'package:redux/redux.dart';
import 'package:HabitShare/features/habits/models/HabitModel.dart';

class AppState {
  final List<HabitModel> habits;
  final List<HabitModel> completedHabits;
  List<HabitModel> events;

  AppState({
    required this.habits,
    required this.completedHabits,
    required this.events,
  });
}

final List<HabitModel> initialHabits = [];

class AddHabitAction {
  final HabitModel habit;
  AddHabitAction(this.habit);
}

class RemoveHabitAction {
  final String habitName;
  RemoveHabitAction(this.habitName);
}

class AddCompletedHabitAction {
  final HabitModel habit;
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
      events: [],
    );
  } else if (action is RemoveHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name != action.habitName;
    }).toList();
    return AppState(
      habits: updatedHabits,
      completedHabits: state.completedHabits,
      events: [],
    );
  } else if (action is AddCompletedHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name !=
          action.habit.name; // Remove the habit with the same name
    }).toList();
    return AppState(
      habits: updatedHabits, // Don't modify habits
      completedHabits: List.from(state.completedHabits), events: [],
    );
  }
  return state;
}

final store = Store<AppState>(
  appReducer,
  initialState: AppState(
    habits: initialHabits,
    completedHabits: [],
    events: [],
  ),
);
