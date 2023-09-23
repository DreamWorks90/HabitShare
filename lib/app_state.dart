import 'package:add_habit_demo_3/habit.dart';
import 'package:add_habit_demo_3/habit_list.dart';
import 'package:redux/redux.dart';

class AppState {
  final List<Habit> habits;

  AppState({required this.habits});
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

AppState appReducer(AppState state, dynamic action) {
  if (action is AddHabitAction) {
    return AppState(
      habits: List.from(state.habits)..add(action.habit),
    );
  } else if (action is RemoveHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name != action.habitName;
    }).toList();
    return AppState(habits: updatedHabits);
  }
  return state;
}

final store = Store<AppState>(
  appReducer,
  initialState: AppState(habits: initialHabits),
);
