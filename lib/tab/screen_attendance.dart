import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AttendanceScreen createState() => _AttendanceScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AttendanceScreen extends State<AttendanceScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime.now(): [
        new Event(
          date: new DateTime.now(),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime.now(),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime.now(),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime.now(),
        new Event(
          date: new DateTime.now(),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime.now(),
        new Event(
          date: new DateTime.now(),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime.now(), [
      new Event(
        date: new DateTime.now(),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime.now(),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime.now(),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  this.setState(() => _currentDate = date);
                },
                weekendTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                thisMonthDayBorderColor: Colors.grey,
                customDayBuilder: (
                  /// you can provide your own build function to make custom day containers
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                ) {
                  // if (day.day == 15) {
                  //   return Center(
                  //     child: Icon(Icons.local_airport),
                  //   );
                  // } else {
                  //   return null;
                  // }
                  return null;
                },
                headerTextStyle: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                iconColor: colorPrimary,
                weekDayBackgroundColor: colorPrimary,
                weekDayFormat: WeekdayFormat.narrow,
                weekFormat: false,
                markedDatesMap: _markedDateMap,
                height: 420.0,
                selectedDateTime: _currentDate,
                headerText: '${DateFormat.yMMMM().format(DateTime.now())}',
                daysTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),

                /// null for not rendering any border, true for circular border, false for rectangular border
              ),
            ),
          ],
        ),
      ),
    );
  }
}
