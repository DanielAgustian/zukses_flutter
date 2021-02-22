import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/component/attendance/time-box.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';

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
  final getFormatListDate = DateFormat.yMMMMd();
  List<AbsenceTime> absensi = dummy;
  AbsenceTime selected;
  DateTime _currentDate = DateTime.now();
  DateTime _date = DateTime.parse("2021-01-02");
  WeeklyCalendar _selectedWeek;
  DateTime _selectedDate;
  List<AbsenceTime> absensiList; 

  void selectDate(DateTime date, AbsenceTime absence) {
    setState(() {
      _currentDate = date;
      selected = absence;
      kata = "$_currentDate";
    });
  }

  bool monthly = true;

  @override
  void initState() { 
    super.initState();
    print("week of year ${_date.weekOfYear}");
    print("week of year ${_date.ordinalDate}");
    print("week of year ${_date.isLeapYear}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                monthly ? FontAwesomeIcons.bars : FontAwesomeIcons.th,
                color: colorPrimary,
              ),
              onPressed: () {
                setState(() {
                  monthly = !monthly;
                });
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: monthly
              ? Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.width <= 569
                          ? size.height * 0.45
                          : size.height * 0.5,
                      child: CalendarWidget(
                        fontSize: size.width <= 569 ? textSizeSmall14 : 12,
                        onSelectDate: (date, absence) {
                          selectDate(date, absence);
                        },
                        data: dummy,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: '${getDayName.format(_currentDate)}, ',
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize:
                                  size.width <= 569 ? textSizeSmall18 : 18),
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
                      height: size.width <= 569 ? 20 : 25,
                    ),
                    TimeBox(
                      selected: selected,
                      fontSize: size.width <= 569 ? textSizeSmall18 : 18,
                    ),
                    SizedBox(height: 15),
                    Container(
                        child: Text(
                      "Overtime : 0 hrs",
                      style: TextStyle(
                          color: colorPrimary,
                          fontSize: size.width <= 569 ? textSizeSmall18 : 18),
                    ))
                  ],
                )
              : Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.06,
                      child: WeekLyCanlendarWidget(
                        fontSize: size.width <= 569 ? textSizeSmall18 : 18,
                        onChangeWeek: (WeeklyCalendar val) { 
                          setState(() {
                            _selectedWeek = val;
                            absensiList = dummy
                                .where((data) => _selectedWeek.firstWeekDate
                                    .isAtSameMomentAs(CustomCalendar()
                                        .findFirstDateOfTheWeek(data.date)))
                                .toList();
                          });
                        },
                        // data: dummy,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    absensiList == null
                        ? Container()
                        : Expanded(
                            child: ListView.builder(
                              itemCount: absensiList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: colorBackground,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 15,
                                            color: colorNeutral150)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                              "${getDayName.format(absensiList[index].date)}",
                                              style: TextStyle(
                                                  color: colorPrimary,
                                                  fontSize: size.width <= 569
                                                      ? textSizeSmall16
                                                      : 16)),
                                          Text(
                                              "${getFormatListDate.format(absensiList[index].date)}",
                                              style: TextStyle(
                                                  color: colorPrimary,
                                                  fontSize: size.width <= 569
                                                      ? textSizeSmall14
                                                      : 14))
                                        ],
                                      ),
                                      TimeBox(
                                        selected: absensiList[index],
                                        space: size.width * 0.01,
                                        fontSize: size.width <= 569
                                            ? textSizeSmall12
                                            : 14,
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
        ));
  }
}
