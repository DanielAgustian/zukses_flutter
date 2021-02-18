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
  final getDayName = DateFormat('EEEE');
  final getDayNumber = DateFormat('d');
  final getMonthName = DateFormat('MMMM');
  final getYearNumber = DateFormat('y');
  List<AbsenceTime> absensi = dummy;
  AbsenceTime selected;
  DateTime _currentDate = DateTime.now();
  // DateTime _currentDate2 = DateTime.now();
  // String _currentMonth = DateFormat.yMMMM().format(DateTime.now());
  // DateTime _targetDateTime = DateTime.now();

  EventList<Event> _markedDateMap = EventList<Event>();

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Attendance Detail",
          style: TextStyle(
              color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: colorPrimary,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  selectDate(date, events);
                },
                markedDatesMap: _markedDateMap,
                height: 420.0,
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
                //Formating header
                headerTextStyle: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                iconColor: colorPrimary,
                //Formating weekend date
                weekendTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                //Formating today
                todayBorderColor: colorPrimary,
                todayButtonColor: colorBackground,
                todayTextStyle: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                ),
                //Formating selected day
                selectedDateTime: _currentDate,
                selectedDayTextStyle: TextStyle(
                    color: colorBackground, fontWeight: FontWeight.bold),
                selectedDayButtonColor: colorPrimary,
                //Formating day
                daysTextStyle:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
                //Formating name of day in Week
                weekFormat: false,
                weekDayBackgroundColor: colorPrimary,
                weekdayTextStyle: TextStyle(color: colorBackground, height: 2),
                weekDayFormat: WeekdayFormat.narrow,
              ),
            ),
            Container(
              child: Text("$kata"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: '${getDayName.format(_currentDate)}, ',
                  style: TextStyle(color: colorPrimary, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${getDayNumber.format(_currentDate)} ',
                    ),
                    TextSpan(
                      text: '${getMonthName.format(_currentDate)} ',
                    ),
                    TextSpan(
                      text: '${getYearNumber.format(_currentDate)} ',
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
            ),
            SizedBox(height: 15),
            Container(
                child: Text(
              "Overtime : 0 hrs",
              style: TextStyle(color: colorPrimary, fontSize: 20),
            ))
          ],
        ),
      ),
    );
  }
}
