import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:zukses_app_1/model/dummy-model.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AttendanceScreen createState() => _AttendanceScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AttendanceScreen extends State<AttendanceScreen> {
  String kata = "";
  final getDayName = DateFormat.yMMMMEEEEd();
  List<AbsenceTime> absensi = dummy;
  AbsenceTime selected;
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

  static Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = EventList<Event>();

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  void selectDate(DateTime date, List<Event> events) {
    setState(() {
      _currentDate = date;
    });

    if (events.length != 0) {
      setState(() {
        selected = absensi.where((data) {
          return data.id == events[0].title;
        }).toList()[0];
      });
    }

    setState(() {
      kata = "$_currentDate";
    });
  }

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    absensi.forEach((data) {
      _markedDateMap.add(
          DateTime.parse(data.date),
          Event(
              date: DateTime.parse(data.date),
              title: data.id,
              dot: data.status == "late" ? dotRed : dotGreen));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  selectDate(date, events);
                },
                weekendTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                thisMonthDayBorderColor: Colors.grey,
                customDayBuilder: (
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
                selectedDayTextStyle: TextStyle(
                    color: colorBackground, fontWeight: FontWeight.bold),
                selectedDayButtonColor: colorPrimary,
                todayBorderColor: colorPrimary,
                todayButtonColor: colorBackground,
                todayTextStyle: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
                headerTextStyle: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                iconColor: colorPrimary,
                markedDatesMap: _markedDateMap,
                height: 420.0,
                selectedDateTime: _currentDate,
                daysTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                weekDayBackgroundColor: colorPrimary,
                weekDayFormat: WeekdayFormat.narrow,
                weekFormat: false,
              ),
            ),
            Container(
              child: Text("$kata"),
            ),
            RichText(
              text: TextSpan(
                text: '${getDayName.format(_currentDate)}, ',
                style: TextStyle(color: colorPrimary, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                      text: 'bold',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' world!'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: colorPrimary, width: 2)),
                  child: Text(
                    "09.10",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
                SizedBox(width: 25),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: colorPrimary,
                ),
                SizedBox(width: 25),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: colorPrimary, width: 2)),
                  child: Text(
                    "09.10",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
