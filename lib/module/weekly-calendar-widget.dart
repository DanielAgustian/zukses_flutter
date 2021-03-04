import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';

class WeekLyCanlendarWidget extends StatefulWidget {
  const WeekLyCanlendarWidget(
      {Key key, this.onChangeWeek, this.fontSize = 18, this.data})
      : super(key: key);

  @override
  _WeekLyCanlendarWidgetState createState() => _WeekLyCanlendarWidgetState();
  final Function onChangeWeek;
  final double fontSize;
  final List<AttendanceModel> data;
}

enum CalendarViews { dates, months, year }

class _WeekLyCanlendarWidgetState extends State<WeekLyCanlendarWidget> {
  DateTime _currentDateTime;
  List<WeeklyCalendar> _sequentialWeek;
  int midYear, week;
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    _currentDateTime = DateTime(date.year, date.month);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // get next month calendar
  void _getNextMonth() {
    if (_currentDateTime.month == 12) {
      _currentDateTime = DateTime(_currentDateTime.year + 1, 1);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month + 1);
    }
    _getCalendar();
  }

  // get previous month calendar
  void _getPrevMonth() {
    if (_currentDateTime.month == 1) {
      _currentDateTime = DateTime(_currentDateTime.year - 1, 12);
    } else {
      _currentDateTime =
          DateTime(_currentDateTime.year, _currentDateTime.month - 1);
    }
    _getCalendar();
  }

  // get calendar for current month
  void _getCalendar() {
    //get now calendar
    var dates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.monday);
    // _sequentialDates = dates;
    //get week calendar
    _sequentialWeek = CustomCalendar().getWeeklyCalendar(calendar: dates);
    _sequentialWeek.forEach((data) {
      if (data.firstWeekDate.isAtSameMomentAs(
          CustomCalendar().findFirstDateOfTheWeek(_currentDateTime))) {
        week = data.week;
      }
    });
  }

  // next / prev month buttons
  Widget _toggleBtn(int add) {
    return InkWell(
      onTap: () {
        setState(() {
          if (week + add > _sequentialWeek.length) {
            _getNextMonth();
            week = 1;
          } else if (week + add < 1) {
            _getPrevMonth();
            week = _sequentialWeek[_sequentialWeek.length - 1].week;
          } else {
            week = week + add;
          }
        });
        widget.onChangeWeek(_sequentialWeek[week - 1]);
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          (add > 0) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: colorPrimary,
        ),
      ),
    );
  }

  // dates view
  Widget _datesView() {
    return Container(
      child: Column(
        children: <Widget>[
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // prev month button
              _toggleBtn(-1),
              SizedBox(width: 20),
              // month and year
              Container(
                child: InkWell(
                  onTap: () {
                    print("click bulan");
                    // setState(() => _currentView = CalendarViews.months);
                  },
                  child: Center(
                    child: Text(
                      '${_monthNames[_currentDateTime.month - 1]} Week ${_sequentialWeek[week - 1].week}',
                      style: TextStyle(
                          color: colorPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              // next month button
              SizedBox(width: 20),
              _toggleBtn(1),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          _sequentialWeek != null ? Center(child: _datesView()) : Container(),
    );
  }
}
