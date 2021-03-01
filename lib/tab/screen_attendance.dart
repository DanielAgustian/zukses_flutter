import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/attendance/time-box.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';

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
  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;

  void timer() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timer();
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
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 20 : 25),
          ),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              icon: FaIcon(
                monthly ? FontAwesomeIcons.bars : FontAwesomeIcons.th,
                color: colorPrimary,
                size: size.height <= 569 ? 16 : 20,
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
          padding: EdgeInsets.all(10),
          child: monthly
              ? Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.width <= 569
                          ? size.height * 0.45
                          : size.height * 0.5,
                      child: CalendarWidget(
                        fontSize: size.height <= 569 ? textSizeSmall14 : 12,
                        onSelectDate: (date, absence) {
                          selectDate(date, absence);
                        },
                        data: dummy,
                      ),
                    ),
                    TitleDayFormatted(
                      currentDate: _currentDate,
                    ),
                    SizedBox(
                      height: size.height <= 569 ? 20 : 25,
                    ),
                    TimeBox(
                      selected: selected,
                      fontSize: size.height <= 569 ? textSizeSmall18 : 18,
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
                        fontSize: size.height <= 569 ? textSizeSmall18 : 18,
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
                            child: isLoading
                                ? ListView.builder(
                                    itemCount: 5,
                                    itemBuilder: (context, index) =>
                                        SkeletonLess3(
                                      size: size,
                                      col: 2,
                                      row: 2,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: absensiList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                            color: colorBackground,
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                        fontSize: size.width <=
                                                                569
                                                            ? textSizeSmall16
                                                            : 16)),
                                                Text(
                                                    "${getFormatListDate.format(absensiList[index].date)}",
                                                    style: TextStyle(
                                                        color: colorPrimary,
                                                        fontSize: size.width <=
                                                                569
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
