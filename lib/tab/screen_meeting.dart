import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _MeetingScreenState extends State<MeetingScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate;
  WeeklyCalendar _selectedWeek;
  List<AbsenceTime> absensiList = dummy;
  int week;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Container(
            //   width: size.width,
            //   height: size.height * 0.5,
            //   child: CalendarWidget(
            //     onSelectDate: (val) {
            //       setState(() {
            //         _selectedDate = val;
            //       });
            //     },
            //     data: dummy,
            //   ),
            // ),
            Container(
              width: size.width,
              height: size.height * 0.5,
              child: WeekLyCanlendarWidget(
                onChangeWeek: (val) {
                  setState(() {
                    _selectedWeek = val;
                  });
                },
                // data: dummy,
              ),
            ),
            Center(
              child: Text(week == null ? "" : 'Week $week'),
            ),
            Center(
              child: Text(_selectedDate == null
                  ? 'This is Tab Meeting'
                  : "${_selectedDate.day}"),
            ),
            Center(
              child: Text(_selectedWeek == null
                  ? 'This is Tab Meeting'
                  : "${_selectedWeek.week} and ${_selectedWeek.firstWeekDate}"),
            ),
          ],
        ),
      )),
    );
  }
  // List<AbsenceTime> absensi = dummy;
  // Map<DateTime, List> _events;
  // List _selectedEvents;
  // AnimationController _animationController;
  // CalendarController _calendarController;

  // @override
  // void initState() {
  //   super.initState();
  //   final _selectedDay = DateTime.now();

  //   _events = {
  //     _selectedDay.subtract(Duration(days: 30)): [
  //       'Event A0',
  //       'Event B0',
  //       'Event C0'
  //     ],
  //     _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
  //     _selectedDay.subtract(Duration(days: 20)): [
  //       'Event A2',
  //       'Event B2',
  //       'Event C2',
  //       'Event D2'
  //     ],
  //     _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
  //     _selectedDay.subtract(Duration(days: 10)): [
  //       'Event A4',
  //       'Event B4',
  //       'Event C4'
  //     ],
  //     _selectedDay.subtract(Duration(days: 4)): [
  //       'Event A5',
  //       'Event B5',
  //       'Event C5'
  //     ],
  //     _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
  //     _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
  //     _selectedDay.add(Duration(days: 1)): [
  //       'Event A8',
  //       'Event B8',
  //       'Event C8',
  //       'Event D8'
  //     ],
  //     _selectedDay.add(Duration(days: 3)):
  //         Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
  //     _selectedDay.add(Duration(days: 7)): [
  //       'Event A10',
  //       'Event B10',
  //       'Event C10'
  //     ],
  //     _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
  //     _selectedDay.add(Duration(days: 17)): [
  //       'Event A12',
  //       'Event B12',
  //       'Event C12',
  //       'Event D12'
  //     ],
  //     _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
  //     _selectedDay.add(Duration(days: 26)): [
  //       'Event A14',
  //       'Event B14',
  //       'Event C14'
  //     ],
  //   };

  //   _selectedEvents = _events[_selectedDay] ?? [];
  //   _calendarController = CalendarController();

  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 400),
  //   );

  //   _animationController.forward();
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   _calendarController.dispose();
  //   super.dispose();
  // }

  // void _onDaySelected(DateTime day, List events, List holidays) {
  //   print('CALLBACK: _onDaySelected');
  //   setState(() {
  //     _selectedEvents = events;
  //   });
  // }

  // void _onVisibleDaysChanged(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   print('CALLBACK: _onVisibleDaysChanged');
  // }

  // void _onCalendarCreated(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   print('CALLBACK: _onCalendarCreated');
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: colorBackground,
  //     body: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       children: <Widget>[
  //         // Switch out 2 lines below to play with TableCalendar's settings
  //         //-----------------------
  //         _buildTableCalendar(),
  //         // _buildTableCalendarWithBuilders(),
  //         const SizedBox(height: 8.0),
  //         Expanded(child: _buildEventList()),
  //       ],
  //     ),
  //   );
  // }

  // // Simple TableCalendar configuration (using Styles)
  // Widget _buildTableCalendar() {
  //   return TableCalendar(
  //     initialCalendarFormat: CalendarFormat.month,
  //     calendarController: _calendarController,
  //     events: _events,
  //     holidays: _holidays,
  //     startingDayOfWeek: StartingDayOfWeek.monday,
  //     daysOfWeekStyle: DaysOfWeekStyle(
  //         decoration: BoxDecoration(
  //             color: colorPrimary, borderRadius: BorderRadius.circular(15)),
  //         weekendStyle: TextStyle(
  //             height: 1.6,
  //             fontSize: 16,
  //             fontWeight: FontWeight.w700,
  //             color: colorBackground),
  //         weekdayStyle: TextStyle(
  //             height: 1.6,
  //             fontSize: 16,
  //             fontWeight: FontWeight.w700,
  //             color: colorBackground)),
  //     availableCalendarFormats: const {
  //       CalendarFormat.month: '',
  //       CalendarFormat.week: '',
  //     },
  //     calendarStyle: CalendarStyle(
  //         selectedColor: colorPrimary,
  //         selectedStyle:
  //             TextStyle(fontWeight: FontWeight.w700, color: colorBackground),
  //         todayColor: colorPrimary30,
  //         markersColor: colorSecondaryRed,
  //         eventDayStyle:
  //             TextStyle(fontWeight: FontWeight.w700, color: colorPrimary),
  //         outsideDaysVisible: false,
  //         weekendStyle:
  //             TextStyle(fontWeight: FontWeight.w700, color: colorPrimary),
  //         weekdayStyle:
  //             TextStyle(fontWeight: FontWeight.w700, color: colorPrimary)),
  //     headerStyle: HeaderStyle(
  //       centerHeaderTitle: true,
  //       formatButtonVisible: false,
  //     ),
  //     onDaySelected: _onDaySelected,
  //     onVisibleDaysChanged: _onVisibleDaysChanged,
  //     onCalendarCreated: _onCalendarCreated,
  //   );
  // }

  // // More advanced TableCalendar configuration (using Builders & Styles)
  // Widget _buildTableCalendarWithBuilders() {
  //   return TableCalendar(
  //     calendarController: _calendarController,
  //     events: _events,
  //     holidays: _holidays,
  //     initialCalendarFormat: CalendarFormat.month,
  //     formatAnimation: FormatAnimation.slide,
  //     startingDayOfWeek: StartingDayOfWeek.sunday,
  //     availableGestures: AvailableGestures.all,
  //     availableCalendarFormats: const {
  //       CalendarFormat.month: '',
  //       CalendarFormat.week: '',
  //     },
  //     calendarStyle: CalendarStyle(
  //       outsideDaysVisible: false,
  //       weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
  //       holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
  //     ),
  //     daysOfWeekStyle: DaysOfWeekStyle(
  //       weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
  //     ),
  //     headerStyle: HeaderStyle(
  //       centerHeaderTitle: true,
  //       formatButtonVisible: false,
  //     ),
  //     builders: CalendarBuilders(
  //       selectedDayBuilder: (context, date, _) {
  //         return FadeTransition(
  //           opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
  //           child: Container(
  //             margin: const EdgeInsets.all(4.0),
  //             padding: const EdgeInsets.only(top: 5.0, left: 6.0),
  //             color: Colors.deepOrange[300],
  //             width: 100,
  //             height: 100,
  //             child: Text(
  //               '${date.day}',
  //               style: TextStyle().copyWith(fontSize: 16.0),
  //             ),
  //           ),
  //         );
  //       },
  //       todayDayBuilder: (context, date, _) {
  //         return Container(
  //           margin: const EdgeInsets.all(4.0),
  //           padding: const EdgeInsets.only(top: 5.0, left: 6.0),
  //           color: Colors.amber[400],
  //           width: 100,
  //           height: 100,
  //           child: Text(
  //             '${date.day}',
  //             style: TextStyle().copyWith(fontSize: 16.0),
  //           ),
  //         );
  //       },
  //       markersBuilder: (context, date, events, holidays) {
  //         final children = <Widget>[];

  //         if (events.isNotEmpty) {
  //           children.add(
  //             Positioned(
  //               right: 1,
  //               bottom: 1,
  //               child: _buildEventsMarker(date, events),
  //             ),
  //           );
  //         }

  //         if (holidays.isNotEmpty) {
  //           children.add(
  //             Positioned(
  //               right: -2,
  //               top: -2,
  //               child: _buildHolidaysMarker(),
  //             ),
  //           );
  //         }

  //         return children;
  //       },
  //     ),
  //     onDaySelected: (date, events, holidays) {
  //       _onDaySelected(date, events, holidays);
  //       _animationController.forward(from: 0.0);
  //     },
  //     onVisibleDaysChanged: _onVisibleDaysChanged,
  //     onCalendarCreated: _onCalendarCreated,
  //   );
  // }

  // Widget _buildEventsMarker(DateTime date, List events) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 300),
  //     decoration: BoxDecoration(
  //       shape: BoxShape.rectangle,
  //       color: _calendarController.isSelected(date)
  //           ? Colors.brown[500]
  //           : _calendarController.isToday(date)
  //               ? Colors.brown[300]
  //               : Colors.blue[400],
  //     ),
  //     width: 16.0,
  //     height: 16.0,
  //     child: Center(
  //       child: Text(
  //         '${events.length}',
  //         style: TextStyle().copyWith(
  //           color: Colors.white,
  //           fontSize: 12.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildHolidaysMarker() {
  //   return Icon(
  //     Icons.add_box,
  //     size: 20.0,
  //     color: Colors.blueGrey[800],
  //   );
  // }

  // Widget _buildButtons() {
  //   final dateTime = _events.keys.elementAt(_events.length - 2);

  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           RaisedButton(
  //             child: Text('Month'),
  //             onPressed: () {
  //               setState(() {
  //                 _calendarController.setCalendarFormat(CalendarFormat.month);
  //               });
  //             },
  //           ),
  //           RaisedButton(
  //             child: Text('2 weeks'),
  //             onPressed: () {
  //               setState(() {
  //                 _calendarController
  //                     .setCalendarFormat(CalendarFormat.twoWeeks);
  //               });
  //             },
  //           ),
  //           RaisedButton(
  //             child: Text('Week'),
  //             onPressed: () {
  //               setState(() {
  //                 _calendarController.setCalendarFormat(CalendarFormat.week);
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8.0),
  //       RaisedButton(
  //         child: Text(
  //             'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
  //         onPressed: () {
  //           _calendarController.setSelectedDay(
  //             DateTime(dateTime.year, dateTime.month, dateTime.day),
  //             runCallback: true,
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildEventList() {
  //   return ListView(
  //     children: _selectedEvents
  //         .map((event) => Container(
  //               decoration: BoxDecoration(
  //                 border: Border.all(width: 0.8),
  //                 borderRadius: BorderRadius.circular(12.0),
  //               ),
  //               margin:
  //                   const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //               child: ListTile(
  //                 title: Text(event.toString()),
  //                 onTap: () => print('$event tapped!'),
  //               ),
  //             ))
  //         .toList(),
  //   );
  // }
}
