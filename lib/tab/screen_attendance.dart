import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/attendance/time-box.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-inbetween.dart';
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
  List<AttendanceModel> absensiList = [];
  bool isLoadingAttendance = false;
  void selectDate(DateTime date, AttendanceModel absence) {
    setState(() {
      _currentDate = date;
      selected = absence;
      /*if (absence.clockIn != null) {
        isLoadingAttendance = true;
      }*/
      kata = "$_currentDate";
    });
  }

  //INIT ATTENDANCE BLOC
  AttendanceBloc _attendanceBloc;

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
    _attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    _attendanceBloc.add(LoadUserAttendanceEvent(date: _currentDate));
    _selectedWeek = WeeklyCalendar(
        date: _currentDate,
        firstWeekDate: CustomCalendar().findFirstDateOfTheWeek(_currentDate));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
      // BLOC when success load
      if (state is AttendanceStateSuccessLoad) {
        print("AttendanceList  = " + state.attendanceList.isEmpty.toString());
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
                    fontSize: size.height <= 569 ? 18 : 22),
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
                      print(state.attendanceList);
                      monthly = !monthly;
                      if (state.attendanceList != null &&
                          state.attendanceList.length > 0 &&
                          monthly == false) {
                        absensiList = state.attendanceList.where((data) {
                          var day = CustomCalendar()
                              .findFirstDateOfTheWeek(data.clockIn);
                          var nowWeek = CustomCalendar()
                              .findFirstDateOfTheWeek(DateTime.now());
                          return (nowWeek.day == day.day &&
                              nowWeek.month == day.month &&
                              nowWeek.year == day.year);
                        }).toList();
                      }
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
                      MaterialPageRoute(
                          builder: (context) => ScreenInBetween()),
                    );
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: monthly
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          state.attendanceList == null
                              ? Center(child: CircularProgressIndicator())
                              : CalendarWidget(
                                  fontSize:
                                      size.height <= 600 ? textSizeSmall16 : 16,
                                  // When select the date
                                  onSelectDate: (date, absence) {
                                    selectDate(date, absence);
                                  },
                                  // When change the month
                                  onClickToggle: (DateTime val) {
                                    _attendanceBloc.add(
                                        LoadUserAttendanceEvent(date: val));
                                  },
                                  data: state.attendanceList,
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
                          OvertimeText(selected: selected, size: size)
                        ],
                      ),
                    )
                  // BLOC when failed load
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
                                absensiList =
                                    state.attendanceList.where((data) {
                                  var day = CustomCalendar()
                                      .findFirstDateOfTheWeek(data.clockIn);
                                  return (_selectedWeek.firstWeekDate.day ==
                                          day.day &&
                                      _selectedWeek.firstWeekDate.month ==
                                          day.month &&
                                      _selectedWeek.firstWeekDate.year ==
                                          day.year);
                                }).toList();
                              });
                            },
                            data: absensiList,
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
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: colorBackground,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                boxShadow: [boxShadowStandard]),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
            ));
      } else if (state is AttendanceStateFailLoad) {
        print("Failed load");
        return noStateLoadSection(size);
      }
      return noStateLoadSection(size);
    });
  }

  // WIDGET when there is no data loaded
  Widget noStateLoadSection(Size size) {
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
              fontSize: size.height <= 569 ? 18 : 22),
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
      body: Container(
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
                          fontSize: size.width <= 569 ? textSizeSmall18 : 18),
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
                                      margin: EdgeInsets.symmetric(vertical: 5),
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
                                                      fontSize:
                                                          size.width <= 569
                                                              ? textSizeSmall16
                                                              : 16)),
                                              Text(
                                                  "${getFormatListDate.format(absensiList[index].clockIn)}",
                                                  style: TextStyle(
                                                      color: colorPrimary,
                                                      fontSize:
                                                          size.width <= 569
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
      ),
    );
  }
}
