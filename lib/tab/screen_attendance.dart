import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/attendance/time-box.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';

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
  List<AttendanceModel> absensi = [];
  AttendanceModel selected;
  DateTime _currentDate = DateTime.now();
  WeeklyCalendar _selectedWeek;
  DateTime _selectedDate;
  List<AttendanceModel> absensiList;

  void selectDate(DateTime date, AttendanceModel absence) {
    setState(() {
      _currentDate = date;
      selected = absence;
      kata = "$_currentDate";
    });
  }

  //INIT ATTENDANCE BLOC
  AttendanceBloc _attendanceBloc = AttendanceBloc();

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
    _attendanceBloc.add(LoadUserAttendanceEvent(date: _currentDate));
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
              size: size.height <= 600 ? 16 : 20,
            ),
            onPressed: () {
              setState(() {
                monthly = !monthly;
              });
            },
          ),
          IconButton(
            splashColor: Colors.transparent,
            icon: FaIcon(
              FontAwesomeIcons.calendarWeek,
              color: colorPrimary,
              size: size.height <= 569 ? 16 : 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenListLeaves()),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          print("state $state");
          if (state is AttendanceStateSuccessLoad) {
            setState(() {
              absensiList = state.attendanceList;
            });
            print(absensiList.length);
            print(absensiList[0].id);
            print(absensiList[0].clockIn);
          } else if (state is AttendanceStateFailLoad) {
            print("Failed load");
          }
          return Container(
            padding: EdgeInsets.all(10),
            child: monthly
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CalendarWidget(
                          fontSize: size.height <= 600 ? textSizeSmall16 : 16,
                          onSelectDate: (date, absence) {
                            selectDate(date, absence);
                          },
                          data: absensiList,
                          size: size,
                        ),
                        SizedBox(height: 20),
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
                              fontSize:
                                  size.width <= 569 ? textSizeSmall18 : 18),
                        ))
                      ],
                    ),
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
                              absensiList
                                  .where((data) => _selectedWeek.firstWeekDate
                                      .isAtSameMomentAs(CustomCalendar()
                                          .findFirstDateOfTheWeek(
                                              data.clockIn)))
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
                                                      "${getDayName.format(absensiList[index].clockIn)}",
                                                      style: TextStyle(
                                                          color: colorPrimary,
                                                          fontSize: size
                                                                      .width <=
                                                                  569
                                                              ? textSizeSmall16
                                                              : 16)),
                                                  Text(
                                                      "${getFormatListDate.format(absensiList[index].clockIn)}",
                                                      style: TextStyle(
                                                          color: colorPrimary,
                                                          fontSize: size
                                                                      .width <=
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
          );
        },
      ),
    );
  }
}
