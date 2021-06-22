import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/attendance/time-box.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/module/weekly-calendar-widget.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';

import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';

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

  // for weekly
  List<AttendanceModel> absensiList = [];
  // for monthly
  List<AttendanceModel> attendanceList;
  bool isLoading = false;
  bool isLoadingAttendance = false;

  //INIT ATTENDANCE BLOC
  AttendanceBloc _attendanceBloc;

  bool monthly = true;
  int companyAcceptance = 1;

  @override
  void initState() {
    super.initState();
    getCompanyAcceptance();
    _attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    _attendanceBloc.add(LoadUserAttendanceEvent(date: _currentDate));
    _selectedWeek = WeeklyCalendar(
        date: _currentDate,
        firstWeekDate: CustomCalendar().findFirstDateOfTheWeek(_currentDate));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        // BLOC when success load
        setState(() {
          if (state is AttendanceStateSuccessLoad) {
            attendanceList = state.attendanceList;
            isLoading = false;

            // auto pass data when open screen
            // used for weekly calendar
            absensiList = attendanceList.where((data) {
              var day = CustomCalendar().findFirstDateOfTheWeek(data.clockIn);
              var nowWeek =
                  CustomCalendar().findFirstDateOfTheWeek(DateTime.now());
              return (nowWeek.day == day.day &&
                  nowWeek.month == day.month &&
                  nowWeek.year == day.year);
            }).toList();

            // auto show data when screen open
            if (attendanceList != null || attendanceList.length > 0) {
              AttendanceModel absence = attendanceList
                  .where((element) => element.clockIn.day == _currentDate.day)
                  .single;
              if (absence != null) selectDate(_currentDate, absence);
            }
          } else if (state is AttendanceStateFailLoad) {
            isLoading = false;
            attendanceList = null;
          } else if (state is AttendanceStateLoading) {
            isLoading = true;
          }
        });
      },
      child: RefreshIndicator(
        color: colorPrimary,
        strokeWidth: 1,
        onRefresh: refreshData,
        child: attendanceList == null
            ? noStateLoadSection(size)
            : buildMainBody(size, context,
                attendanceList: attendanceList, loading: isLoading),
      ),
    );
  }

  // THE MAIN BODY
  Widget buildMainBody(Size size, BuildContext context,
      {List<AttendanceModel> attendanceList, bool loading}) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        automaticallyImplyLeading: false,
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
                if ((attendanceList != null && attendanceList.length > 0) ||
                    monthly == false) {
                  _attendanceBloc
                      .add(LoadUserAttendanceEvent(date: _currentDate));
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              child: Container(
                child: SvgPicture.asset(
                  "assets/images/leave-symbol.svg",
                  height: size.height <= 569 ? 20 : 25,
                  width: size.height <= 569 ? 20 : 25,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScreenListLeaves(permission: "leaves")),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/images/overtime-symbol.svg",
                height: size.height <= 569 ? 20 : 25,
                width: size.height <= 569 ? 20 : 25,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScreenListLeaves(permission: "overtime")),
                );
              },
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
            padding: EdgeInsets.all(10),
            child: monthly
                ? buildMonthlyView(size,
                    attendanceList: attendanceList, loading: loading)
                // Weekly Calendar
                : buildWeeklyView(size,
                    attendanceList: attendanceList, loading: loading)),
      ),
    );
  }

  // Build weekly view calendar
  Widget buildWeeklyView(Size size,
      {List<AttendanceModel> attendanceList, bool loading}) {
    return Column(
      children: [
        SizedBox(
          height: 13,
        ),
        Container(
          width: size.width,
          height: size.height * 0.06,
          child: WeekLyCanlendarWidget(
            fontSize: size.height <= 569 ? textSizeSmall18 : 18,
            onChangeWeek: (WeeklyCalendar val) {
              setState(() {
                _selectedWeek = val;
                absensiList = attendanceList.where((data) {
                  var day =
                      CustomCalendar().findFirstDateOfTheWeek(data.clockIn);
                  return (_selectedWeek.firstWeekDate.day == day.day &&
                      _selectedWeek.firstWeekDate.month == day.month &&
                      _selectedWeek.firstWeekDate.year == day.year);
                }).toList();
              });
            },
            data: absensiList,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: loading
              ? ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => SkeletonLess3(
                    size: size,
                    col: 2,
                    row: 2,
                  ),
                )
              : absensiList == null || absensiList.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: absensiList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [boxShadowStandard]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${getDayName.format(absensiList[index].clockIn)}",
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: size.width <= 569
                                              ? textSizeSmall18
                                              : 18)),
                                  Text(
                                      "${getFormatListDate.format(absensiList[index].clockIn)}",
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: size.width <= 569
                                              ? textSizeSmall16
                                              : 16))
                                ],
                              ),
                              TimeBox(
                                selected: absensiList[index],
                                space: size.width * 0.01,
                                fontSize:
                                    size.width <= 569 ? textSizeSmall18 : 18,
                              )
                            ],
                          ),
                        );
                      },
                    ),
        )
      ],
    );
  }

  // Build monthly view calendar
  Widget buildMonthlyView(Size size,
      {List<AttendanceModel> attendanceList, bool loading}) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarWidget(
            fontSize: size.height <= 600 ? textSizeSmall16 : 16,
            // When select the date
            onSelectDate: (date, absence) {
              selectDate(date, absence);
            },
            // When change the month
            onClickToggle: (DateTime val) {
              _attendanceBloc.add(LoadUserAttendanceEvent(date: val));
            },
            data: attendanceList,
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
    );
  }

  // WIDGET when there is no data loaded
  Widget noStateLoadSection(Size size) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        automaticallyImplyLeading: false,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              child: Container(
                child: SvgPicture.asset(
                  "assets/images/leave-symbol.svg",
                  height: size.height <= 569 ? 20 : 25,
                  width: size.height <= 569 ? 20 : 25,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScreenListLeaves(permission: "leaves")),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/images/overtime-symbol.svg",
                height: size.height <= 569 ? 20 : 25,
                width: size.height <= 569 ? 20 : 25,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScreenListLeaves(permission: "overtime")),
                );
              },
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
            padding: EdgeInsets.all(10),
            child: monthly
                ? buildMonthlyView(size, loading: false)
                : buildWeeklyView(size, loading: false)),
      ),
    );
  }

  Widget freeVerLayout(BuildContext context, Size size) {
    return Center(
      child: Container(
        width: size.width,
        height: 0.8 * size.height,
        child: Center(
          child: Text(
            "Please buy the full version to get Attendance function",
            style: TextStyle(
                fontSize: size.height < 569 ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: colorPrimary),
          ),
        ),
      ),
    );
  }

  // --------------------------Logic-----------------------------//

  Future<void> refreshData() async {
    DateTime _currentDate = DateTime.now();
    getCompanyAcceptance();
    _attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    _attendanceBloc.add(LoadUserAttendanceEvent(date: _currentDate));
    _selectedWeek = WeeklyCalendar(
        date: _currentDate,
        firstWeekDate: CustomCalendar().findFirstDateOfTheWeek(_currentDate));
  }

  void selectDate(DateTime date, AttendanceModel absence) {
    setState(() {
      _currentDate = date;
      selected = absence;

      kata = "$_currentDate";
    });
  }

  // check company of the user
  getCompanyAcceptance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      companyAcceptance = prefs.getInt("in-company");
    });
  }

  // handle click back on android
  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenTab(
                  index: 0,
                )));
    return false;
  }
}
