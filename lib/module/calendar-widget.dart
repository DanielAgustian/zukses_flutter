import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/module/calendar-model.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget(
      {Key key, this.onSelectDate, this.data, this.fontSize = 14})
      : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
  final Function onSelectDate;
  final List data;
  final double fontSize;
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
    Size size = MediaQuery.of(context).size;
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
    print(_sequentialDates.length);
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
                  print("click bulan");
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
    if (_sequentialDates == null) return Container();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _sequentialDates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisCount: 7,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          // if (_sequentialDates[index].date == _selectedDateTime)
          //   return _selector(_sequentialDates[index]);
          return _calendarDates(_sequentialDates[index],
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

  // calendar element
  Widget _calendarDates(Calendar calendarDate,
      {int index, List<AbsenceTime> data}) {
    Widget dot = Container();
    AbsenceTime absence;
    if (data != null) {
      for (var d in data) {
        if (d.date.isAtSameMomentAs(calendarDate.date)) {
          dot = d.status == "late" ? dotRed : dotGreen;
          absence = d;
          break;
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
