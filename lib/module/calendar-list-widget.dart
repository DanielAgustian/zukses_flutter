import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';

class CalendarListWidget extends StatefulWidget {
  const CalendarListWidget(
      {Key key, this.onSelectDate, this.fontSize = 14, this.data})
      : super(key: key);

  @override
  _CalendarListWidgetState createState() => _CalendarListWidgetState();
  final Function onSelectDate;
  final double fontSize;
  final List data;
}

enum CalendarViews { dates, months, year }

class _CalendarListWidgetState extends State<CalendarListWidget> {
  DateTime _currentDateTime;
  DateTime _selectedDateTime;
  List<Calendar> _sequentialDates;
  DateFormat getDayName = DateFormat.E();
  int midYear;
  CalendarViews _currentView = CalendarViews.dates;

  final date = DateTime.now();

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
    return Scaffold(
      body: Center(
        child: Container(
            // margin: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: (_currentView == CalendarViews.dates)
                ? _datesView()
                : (_currentView == CalendarViews.months)
                    ? _showMonthsList()
                    : _yearsView(midYear ?? _currentDateTime.year)),
      ),
    );
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
              child: InkWell(
                onTap: () {
                  setState(() => _currentView = CalendarViews.months);
                },
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
            ),
            // next month button
            SizedBox(width: 20),
            _toggleBtn(true),
          ],
        ),
        SizedBox(
          height: 10,
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
          setState(() {});
        }
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
    ScrollController _controller =
        ScrollController(initialScrollOffset: 32 * double.parse("${date.day}"));
    if (_sequentialDates == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _sequentialDates.length,
        controller: _controller,
        itemBuilder: (context, index) { 
          return _calendarDates(_sequentialDates[index], data: widget.data);
        },
      ),
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
  Widget _calendarDates(Calendar calendarDate, {List<ScheduleModel> data}) {
    Widget dot = Container();

    // Condition for calendar in Screen `Schedule`
    if (data != null) {
      if (checkTheDate(calendarDate: calendarDate)) {
        for (var d in data) {
          if (d.date.day == calendarDate.date.day &&
              d.date.month == calendarDate.date.month &&
              d.date.year == calendarDate.date.year) {
            _selectedDateTime != calendarDate.date
                ? dot = dotGreen
                : dot = dotWhite;
            break;
          }
        }
      } else {
        var i = 0;
        while (i < data.length) {
          // if the data founded
          if (data[i].date.day == calendarDate.date.day &&
              data[i].date.month == calendarDate.date.month &&
              data[i].date.year == calendarDate.date.year) {
            _selectedDateTime != calendarDate.date
                ? dot = dotGreen
                : dot = dotWhite;
            break;
          }

          // if `calendar date day` - 15 > 5, then iteration + 3
          if (15 - data[i].date.day > 5 && i + 3 < data.length) {
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
          widget.onSelectDate(calendarDate.date);
        },
        child: _selectedDateTime != calendarDate.date
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${getDayName.format(calendarDate.date)}',
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          color: (calendarDate.thisMonth)
                              ? colorPrimary
                              : colorNeutral2,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${calendarDate.date.day}',
                        style: TextStyle(
                          fontSize: widget.fontSize + 4,
                          fontWeight: FontWeight.bold,
                          color: (calendarDate.thisMonth)
                              ? colorPrimary
                              : colorNeutral2,
                        )),
                    dot
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${getDayName.format(calendarDate.date)}',
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                          color: (calendarDate.thisMonth)
                              ? colorBackground
                              : colorNeutral2,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${calendarDate.date.day}',
                        style: TextStyle(
                          fontSize: widget.fontSize + 4,
                          fontWeight: FontWeight.bold,
                          color: (calendarDate.thisMonth)
                              ? colorBackground
                              : colorNeutral2,
                        )),
                    dot
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
