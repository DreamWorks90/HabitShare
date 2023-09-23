import 'package:redux/redux.dart';

// Actions
enum CalendarActionType { addEvent, removeEvent }

class CalendarAction {
  final CalendarActionType type;
  final CalendarEvent event;

  CalendarAction(this.type, this.event);
}

class CalendarEvent {
  final String title;
  final DateTime date;

  CalendarEvent(this.title, this.date);
}

List<CalendarEvent> calendarReducer(List<CalendarEvent> state, dynamic action) {
  if (action is CalendarAction) {
    switch (action.type) {
      case CalendarActionType.addEvent:
        return [...state, action.event];
      case CalendarActionType.removeEvent:
        return state.where((event) => event != action.event).toList();
      default:
        return state;
    }
  }
  return state;
}

final Store<List<CalendarEvent>> store = Store<List<CalendarEvent>>(
  calendarReducer,
  initialState: [],
);
