import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget(
      {Key key,
      this.onSelectDate,
      this.data,
      this.fontSize = 14,
      this.size,
      this.onClickToggle})
      : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
  final double fontSize;
  final List data;
  final Size size;

  // callback function when select date
  final Function onSelectDate;

  //callback function when change the month
  final Function onClickToggle;
}

enum CalendarViews { dates, months, year }

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _currentDateTime;
  DateTime _selectedDateTime;
  List<Calendar> _sequentialDates;
  int midYear;
  CalendarViews _currentView = CalendarViews.dates;
  final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
  ];
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
    _selectedDateTime = DateTime(date.year, date.month, date.day);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _getCalendar());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: (_currentView == CalendarViews.dates)
            ? _datesView()
            : (_currentView == CalendarViews.months)
                ? _showMonthsList()
                : _yearsView(midYear ?? _currentDateTime.year));
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
    _sequentialDates = CustomCalendar().getMonthCalendar(
        _currentDateTime.month, _currentDateTime.year,
        startWeekDay: StartWeekDay.monday);
  }

  // dates view
  Widget _datesView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // prev month button
            _toggleBtn(false),
            SizedBox(width: 20),
            // month and year
            Container(
              child: Center(
                child: Text(
                  '${_monthNames[_currentDateTime.month - 1]} ${_currentDateTime.year}',
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            // next month button
            SizedBox(width: 20),
            _toggleBtn(true),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _weekDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisCount: 7,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              // if (_sequentialDates[index].date == _selectedDateTime)
              //   return _selector(_sequentialDates[index]);
              return Center(child: _weekDayTitle(index));
            },
          ),
        ),
        Flexible(child: _calendarBody()),
      ],
    );
  }

  // next / prev month buttons
  Widget _toggleBtn(bool next) {
    return InkWell(
      onTap: () {
        if (_currentView == CalendarViews.dates) {
          setState(() {
            (next) ? _getNextMonth() : _getPrevMonth();
          });
        } else if (_currentView == CalendarViews.year) {
          if (next) {
            midYear =
                (midYear == null) ? _currentDateTime.year + 9 : midYear + 9;
          } else {
            midYear =
                (midYear == null) ? _currentDateTime.year - 9 : midYear - 9;
          }
        }
        widget.onClickToggle(_currentDateTime);
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          (next) ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: colorPrimary,
        ),
      ),
    );
  }

  // calendar
  Widget _calendarBody() {
    if (_sequentialDates == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _sequentialDates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisCount: 7,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return widget.data.toString() == "null"
              ? _calendarDates(_sequentialDates[index], index: index)
              : widget.data.isEmpty
                  ? _calendarDates(_sequentialDates[index], index: index)
                  : widget.data[0] is ScheduleModel
                      // calendar for `schedule screen`
                      ? _calendarDates(_sequentialDates[index],
                          index: index, data2: widget.data)

                      // calendar for `attendance screen`
                      : _calendarDates(_sequentialDates[index],
                          index: index, data: widget.data);
        },
      ),
    );
  }

  // calendar header
  Widget _weekDayTitle(int index) {
    return Text(
      _weekDays[index],
      style: TextStyle(color: colorBackground, fontSize: widget.fontSize - 2),
    );
  }

  // function to check the calendar date
  // is it less than 15 or no
  // `true` if less than 15, `false` is more than or equal to 15
  bool checkTheDate({Calendar calendarDate}) {
    // If the date is less than 15
    // Or it's a date from previous month
    // Or it's a date from previous year
    if (calendarDate.date.day < 15 ||
        calendarDate.date.month - 1 < calendarDate.date.month ||
        calendarDate.date.year - 1 < calendarDate.date.year) {
      return true;
    }

    // If the date is more than or equal 15
    // Or it's a date from next month
    // Or it's a date from next year
    return false;
  }

  // calendar element
  Widget _calendarDates(Calendar calendarDate,
      {int index, List<AttendanceModel> data, List<ScheduleModel> data2}) {
    Widget dot = Container();
    AttendanceModel absence;

    // Condition for calendar in Screen `Attendance`
    // Make sure absensi list from backend has been sorted ascending
    if (data != null) {
      if (checkTheDate(calendarDate: calendarDate)) {
        for (var d in data) {
          if (d.clockIn.day == calendarDate.date.day &&
              d.clockIn.month == calendarDate.date.month &&
              d.clockIn.year == calendarDate.date.year) {
            dot = d.isLate == "yes" ? dotRed : dotGreen;
            absence = d;
            break;
          }
        }
      } else {
        var i = 0;
        while (i < data.length) {
          // if the data founded
          if (data[i].clockIn.day == calendarDate.date.day &&
              data[i].clockIn.month == calendarDate.date.month &&
              data[i].clockIn.year == calendarDate.date.year) {
            dot = data[i].isLate == "late" ? dotRed : dotGreen;
            absence = data[i];
            break;
          }

          // if `calendar date day` - 15 > 5, then iteration + 3
          if (15 - data[i].clockIn.day > 5 && i + 3 < data.length) {
            i = i + 3;
          } else {
            i++;
          }
        }
      }
    }

    // Condition for calendar in Screen `Schedule`
    if (data2 != null) {
      if (checkTheDate(calendarDate: calendarDate)) {
        for (var d in data2) {
          if (d.date.day == calendarDate.date.day &&
              d.date.month == calendarDate.date.month &&
              d.date.year == calendarDate.date.year) {
            dot = dotGreen;
            break;
          }
        }
      } else {
        var i = 0;
        while (i < data2.length) {
          // if the data founded
          if (data2[i].date.day == calendarDate.date.day &&
              data2[i].date.month == calendarDate.date.month &&
              data2[i].date.year == calendarDate.date.year) {
            dot = dotBlue;
            break;
          }

          // if `calendar date day` - 15 > 5, then iteration + 3
          if (15 - data2[i].date.day > 5 && i + 3 < data2.length) {
            i = i + 3;
          } else {
            i++;
          }
        }
      }
    }

    return InkWell(
        onTap: () {
          if (_selectedDateTime != calendarDate.date) {
            setState(() => _selectedDateTime = calendarDate.date);
            if (calendarDate.nextMonth) {
              setState(() {
                _selectedDateTime = null;
              });
              _getNextMonth();
            } else if (calendarDate.prevMonth) {
              setState(() {
                _selectedDateTime = null;
              });
              _getPrevMonth();
            }
          }
          widget.onSelectDate(calendarDate.date, absence);
        },
        child: _selectedDateTime != calendarDate.date
            ? Container(
                child: Stack(
                  children: [
                    Center(
                        child: Text(
                      '${calendarDate.date.day}',
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        color: (calendarDate.thisMonth)
                            ? colorPrimary
                            : colorNeutral2,
                      ),
                    )),
                    Container(alignment: Alignment.bottomCenter, child: dot)
                  ],
                ),
              )
            : Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: colorPrimary, width: 2),
                ),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      '${calendarDate.date.day}',
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        color: (calendarDate.thisMonth)
                            ? colorPrimary
                            : colorNeutral2,
                      ),
                    )),
                    Container(alignment: Alignment.bottomCenter, child: dot)
                  ],
                ),
              ));
  }

  // show months list
  Widget _showMonthsList() {
    return Container(
      decoration: BoxDecoration(
          color: colorPrimary, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _currentView = CalendarViews.year),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${_currentDateTime.year}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _monthNames.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  _currentDateTime = DateTime(_currentDateTime.year, index + 1);
                  _getCalendar();
                  setState(() => _currentView = CalendarViews.dates);
                },
                title: Center(
                  child: Text(
                    _monthNames[index],
                    style: TextStyle(
                        fontSize: 18,
                        color: (index == _currentDateTime.month - 1)
                            ? colorSecondaryYellow
                            : colorBackground),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // years list views
  Widget _yearsView(int midYear) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _toggleBtn(false),
              Spacer(),
              _toggleBtn(true),
            ],
          ),
          Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int thisYear;
                  if (index < 4) {
                    thisYear = midYear - (4 - index);
                  } else if (index > 4) {
                    thisYear = midYear + (index - 4);
                  } else {
                    thisYear = midYear;
                  }
                  return ListTile(
                    onTap: () {
                      _currentDateTime =
                          DateTime(thisYear, _currentDateTime.month);
                      _getCalendar();
                      setState(() => _currentView = CalendarViews.months);
                    },
                    title: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '$thisYear',
                        style: TextStyle(
                            fontSize: 18,
                            color: (thisYear == _currentDateTime.year)
                                ? colorSecondaryYellow
                                : colorPrimary),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
