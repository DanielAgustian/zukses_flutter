import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/schedule-item.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/module/calendar-list-widget.dart'; 
import 'package:zukses_app_1/module/calendar-widget.dart'; 
import 'package:zukses_app_1/screen/schedule/screen-add-schedule.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _MeetingScreenState extends State<MeetingScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate;
  List<AbsenceTime> absensiList = dummy;
  int week;
  DateTime _currentDate = DateTime.now();
  bool grid = true;

  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  void selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // selected = absence;
      // kata = "$_currentDate";
    });
    print(_selectedDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = _currentDate;
    _controller = AnimationController(vsync: this, duration: _duration);
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
            "Schedule",
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 20 : 25),
          ),
          actions: [
            IconButton(
              splashColor: Colors.transparent,
              icon: FaIcon(
                  grid ? FontAwesomeIcons.columns : FontAwesomeIcons.box,
                  color: colorPrimary,
                  size: size.height <= 569 ? 16 : 20),
              onPressed: () {
                setState(() {
                  grid = !grid;
                });
              },
            ),
            IconButton(
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.search,
                color: colorPrimary,
                size: size.height <= 569 ? 16 : 20,
              ),
              onPressed: () {},
            ),
            IconButton(
              splashColor: Colors.transparent,
              icon: FaIcon(FontAwesomeIcons.plusCircle,
                  color: colorPrimary, size: size.height <= 569 ? 16 : 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddScheduleScreen()),
                );
              },
            )
          ],
        ),
        body: Stack(
          children: [
            grid
                ? Container(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          width: size.width,
                          height: size.height <= 569
                              ? size.height * 0.45
                              : size.height * 0.4,
                          child: CalendarWidget(
                            fontSize: size.width <= 569 ? textSizeSmall14 : 12,
                            onSelectDate: (date, absence) {
                              selectDate(date);
                            },
                            data: dummy,
                          ),
                        ),
                        TitleDayFormatted(
                          currentDate: _selectedDate,
                        ),
                        ...absensiList
                            .map((item) => InkWell(
                                  onTap: () {
                                    if (_controller.isDismissed)
                                      _controller.forward();
                                    else if (_controller.isCompleted)
                                      _controller.reverse();
                                  },
                                  child: ScheduleItem(
                                    size: size,
                                    title: "Schedule",
                                    time1: "10.00",
                                    time2: "11.30",
                                  ),
                                ))
                            .toList() 
                      ],
                    ),
                  ))
                : Container(
                    child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height <= 569
                            ? size.height * 0.21
                            : size.height * 0.17,
                        child: CalendarListWidget(
                          fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                          onSelectDate: (date) {
                            selectDate(date);
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (_controller.isDismissed)
                                    _controller.forward();
                                  else if (_controller.isCompleted)
                                    _controller.reverse();
                                },
                                child: ScheduleItem(
                                  size: size,
                                  title: "Schedule",
                                  time1: "10.00",
                                  time2: "11.30",
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            SizedBox.expand(
              child: SlideTransition(
                position: _tween.animate(_controller),
                child: DraggableScrollableSheet(
                  maxChildSize: 0.8,
                  initialChildSize: 0.8,
                  minChildSize: 0.3,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(blurRadius: 15)],
                          color: colorBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.26),
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Column(
                                  children: [
                                    ...dummy.map((item) => Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          child: Row(
                                            children: [
                                              UserAvatar(
                                                avatarRadius: size.height <= 570
                                                    ? 15
                                                    : 20,
                                                dotSize:
                                                    size.height <= 570 ? 8 : 10,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "User (status)",
                                                style: TextStyle(
                                                  fontSize: size.height <= 570
                                                      ? 14
                                                      : 16,
                                                  color: colorPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                LongButton(
                                  size: size,
                                  bgColor: colorPrimary,
                                  textColor: colorBackground,
                                  title: "Accept",
                                  onClick: () {},
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                LongButtonOutline(
                                  outlineColor: colorError,
                                  size: size,
                                  bgColor: colorBackground,
                                  textColor: colorError,
                                  title: "Reject",
                                  onClick: () {},
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.25,
                            color: colorBackground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Schedule",
                                      style: TextStyle(
                                          fontSize:
                                              size.height <= 570 ? 18 : 20,
                                          color: colorPrimary,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    IconButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.times,
                                        color: colorPrimary,
                                      ),
                                      onPressed: () {
                                        _controller.reverse();
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height <= 570 ? 2 : 5,
                                ),
                                Text(
                                  "09.00 - 10.00",
                                  style: TextStyle(
                                    fontSize: size.height <= 570 ? 12 : 14,
                                    color: colorPrimary50,
                                  ),
                                ),
                                SizedBox(
                                  height: size.height <= 570 ? 6 : 10,
                                ),
                                Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tellus adipiscing fusce egestas fames diam velit, vulputate.",
                                  style: TextStyle(
                                    fontSize: size.height <= 570 ? 12 : 14,
                                    color: colorPrimary,
                                  ),
                                ),
                                SizedBox(
                                  height: size.height <= 570 ? 10 : 20,
                                ),
                                Text(
                                  "Assigned to",
                                  style: TextStyle(
                                      fontSize: size.height <= 570 ? 12 : 14,
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
