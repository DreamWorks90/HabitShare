/*import 'package:redux/redux.dart';
import 'package:HabitShare/features/habits/models/HabitModel.dart';

class AppState {
  final List<HabitModelRedux> habits;
  final List<HabitModelRedux> completedHabits;
  List<HabitModelRedux> events;

  AppState({
    required this.habits,
    required this.completedHabits,
    required this.events,
  });
}

final List<HabitModelRedux> initialHabits = [];

class FetchHabitsAction {
  final List<HabitModelRedux> habits;
  FetchHabitsAction(this.habits);
}

class AddHabitAction {
  final HabitModelRedux habitRedux;
  AddHabitAction(this.habitRedux);
}

class RemoveHabitAction {
  final String habitName;
  RemoveHabitAction(this.habitName);
}

class AddCompletedHabitAction {
  final HabitModelRedux habit;
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
      habits: List.from(state.habits)..add(action.habitRedux),
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
  } else if (action is FetchHabitsAction) {
    return AppState(
      habits: action.habits, completedHabits: state.completedHabits, events: [],
      // Copy other properties from the existing state if needed
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
);*/
