import 'package:redux/redux.dart';
import '../AddHabit/Habit.dart';

class AppState {
  final List<Habit> habits;
  final List<Habit> completedHabits;
  final DateTime? startDate;
  final DateTime? endDate;

  AppState({
    required this.habits,
    required this.completedHabits,
    this.startDate,
    this.endDate,
  });

  AppState copyWith({
    List<Habit>? habits,
    List<Habit>? completedHabits,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AppState(
      habits: habits ?? this.habits,
      completedHabits: completedHabits ?? this.completedHabits,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
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

class RemoveCompletedHabitAction {
  final String habitName;
  RemoveCompletedHabitAction(this.habitName);
}

class SetStartDateAction {
  final DateTime startDate;
  SetStartDateAction(this.startDate);
}

class SetEndDateAction {
  final DateTime endDate;
  SetEndDateAction(this.endDate);
}

AppState appReducer(AppState state, dynamic action) {
  if (action is AddHabitAction) {
    return state.copyWith(habits: List.from(state.habits)..add(action.habit));
  } else if (action is RemoveHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name != action.habitName;
    }).toList();
    return state.copyWith(habits: updatedHabits);
  } else if (action is AddCompletedHabitAction) {
    final updatedHabits = state.habits.where((habit) {
      return habit.name != action.habit.name;
    }).toList();
    return state.copyWith(habits: updatedHabits);
  } else if (action is RemoveCompletedHabitAction) {
    final updatedCompletedHabits = state.completedHabits.where((habit) {
      return habit.name != action.habitName;
    }).toList();
    return state.copyWith(completedHabits: updatedCompletedHabits);
  } else if (action is SetStartDateAction) {
    return state.copyWith(startDate: action.startDate);
  } else if (action is SetEndDateAction) {
    return state.copyWith(endDate: action.endDate);
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
