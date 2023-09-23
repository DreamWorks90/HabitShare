import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'redux_store.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(const ViewSwitching());

CalendarController? _controller = CalendarController();

class ViewSwitching extends StatefulWidget {
  const ViewSwitching({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

class ScheduleExample extends State<ViewSwitching> {
  final List<String> _colors = <String>[
    'Pink',
    'Blue',
    'Wall Brown',
    'Yellow',
    'Default'
  ];
  final CalendarController _controller = CalendarController();
  Color? _headerColor, _viewHeaderColor, _calendarColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.color_lens),
              itemBuilder: (BuildContext context) {
                return _colors.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (String value) {
                setState(() {
                  if (value == 'Pink') {
                    _headerColor = const Color(0xFF09e8189);
                    _viewHeaderColor = const Color(0xFF0f3acb6);
                    _calendarColor = const Color(0xFF0ffe5d8);
                  } else if (value == 'Blue') {
                    _headerColor = const Color(0xFF0007eff);
                    _viewHeaderColor = const Color(0xFF03aa4f6);
                    _calendarColor = const Color(0xFF0bae5ff);
                  } else if (value == 'Wall Brown') {
                    _headerColor = const Color(0xFF0937c5d);
                    _viewHeaderColor = const Color(0xFF0e6d9b1);
                    _calendarColor = const Color(0xFF0d1d2d6);
                  } else if (value == 'Yellow') {
                    _headerColor = const Color(0xFF0f7ed53);
                    _viewHeaderColor = const Color(0xFF0fff77f);
                    _calendarColor = const Color(0xFF0f7f2cc);
                  } else if (value == 'Default') {
                    _headerColor = null;
                    _viewHeaderColor = null;
                    _calendarColor = null;
                  }
                });
              },
            ),
          ],
          backgroundColor: _headerColor,
        ),
        body: SfCalendar(
          view: CalendarView.week,
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.workWeek,
            CalendarView.month,
            CalendarView.timelineDay,
            CalendarView.timelineWeek,
            CalendarView.timelineWorkWeek
          ],
          viewHeaderStyle: ViewHeaderStyle(backgroundColor: _viewHeaderColor),
          backgroundColor: _calendarColor,
          controller: _controller,
          initialDisplayDate: DateTime.now(),
          dataSource: getCalendarDataSource(),
          onTap: calendarTapped,
          monthViewSettings: const MonthViewSettings(
              navigationDirection: MonthNavigationDirection.vertical),
        ),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_currentView == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _currentView = CalendarView.day;
    } else if ((_currentView == CalendarView.week ||
        _currentView == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _currentView = CalendarView.day;
    }
  }


  _DataSource getCalendarDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      subject: 'Meeting',
      color: Colors.pink,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Release Meeting',
      color: Colors.lightBlueAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 6)),
      endTime: DateTime.now().add(const Duration(hours: 7)),
      subject: 'Performance check',
      color: Colors.amber,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 1, 22, 1, 0, 0),
      endTime: DateTime(2020, 1, 22, 3, 0, 0),
      subject: 'Support',
      color: Colors.green,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 1, 24, 3, 0, 0),
      endTime: DateTime(2020, 1, 24, 4, 0, 0),
      subject: 'Retrospective',
      color: Colors.purple,
    ));

    return _DataSource(appointments);
  }
}

class CalendarController {
  get view => null;
}

class _DataSource extends CalendarDataSource {
  _DataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar App',
      home: CalendarApp(),
    );
  }
}

class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendar App'),
        ),
        body: Column(
          children: [
            CalendarView(),
            EventList(),
          ],
        ),
        floatingActionButton: AddEventButton(),
      ),
    );
  }
}

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement the calendar view here
    return Container(
      // Your calendar widget goes here
    );
  }
}

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<List<CalendarEvent>, List<CalendarEvent>>(
      converter: (Store<List<CalendarEvent>> store) => store.state,
      builder: (BuildContext context, List<CalendarEvent> events) {
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(
              title: Text(event.title),
              subtitle: Text(event.date.toString()),
              // Implement event deletion functionality here
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  StoreProvider.of<List<CalendarEvent>>(context)
                      .dispatch(CalendarAction(
                    CalendarActionType.removeEvent,
                    event,
                  ));
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Implement logic to show a dialog for adding events
        showDialog(
          context: context,
          builder: (context) {
            // Your event creation form goes here
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
*/