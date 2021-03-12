import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/meeting-services.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:zukses_app_1/module/calendar-list-widget.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';
import 'package:zukses_app_1/component/schedule/schedule-item.dart';
import 'package:zukses_app_1/screen/meeting/screen-add-schedule.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';
import 'package:zukses_app_1/util/util.dart';

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate;
  // List<AbsenceTime> absensiList = dummy;
  int week;
  DateTime _currentDate = DateTime.now();
  bool grid = true;
  bool removeBackgroundDialog = false;

  // Draggable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  //STRING FOR GLOBAL VARIABLE
  String meetingID;
  List<String> date1 = [], date2 = [];
  void selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // selected = absence;
      // kata = "$_currentDate";
    });
    print(_selectedDate);
  }

  Util util;
  //INIT BLOC
  MeetingBloc _meetingBloc;
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
    // TODO: implement initState
    super.initState();
    _meetingBloc = BlocProvider.of<MeetingBloc>(context);
    _meetingBloc.add(LoadAllMeetingEvent());
    _selectedDate = _currentDate;
    util = Util();
    _controller = AnimationController(vsync: this, duration: _duration);
    timer();
  }

  /*void postHTTPdemo() async {
    ScheduleModel scheduleModel =
        await MeetingServicesHTTP().fetchScheduleDetail("3");
    print(scheduleModel.title);
  }*/

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
            PopupMenuButton(
              icon: FaIcon(
                FontAwesomeIcons.ellipsisH,
                color: colorPrimary,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSelected: (val) {
                switch (val) {

                  // Move to add schedule screen
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddScheduleScreen()),
                    );
                    break;

                  // Move to request meeting screen
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestInbox()));
                    break;

                  // Change the calendar view type
                  case 3:
                    setState(() {
                      grid = !grid;
                    });
                    break;

                  // Move to search screen
                  case 4:
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.plusCircle,
                            color: colorPrimary,
                            size: size.height <= 569 ? 16 : 20),
                        SizedBox(width: 5),
                        Text(
                          'Add Schedule',
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 600 ? 11 : 13),
                        )
                      ],
                    )),
                PopupMenuItem(
                    value: 2,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.bell,
                                  color: colorPrimary,
                                  size: size.height <= 569 ? 16 : 20),
                              SizedBox(width: 5),
                              Text(
                                'Request',
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontSize: size.height < 600 ? 11 : 13),
                              ),
                            ],
                          ),
                          Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorSecondaryRed),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                      color: colorBackground,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height < 600 ? 8 : 10),
                                ),
                              ))
                        ],
                      ),
                    )),
                PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: <Widget>[
                        FaIcon(
                            grid
                                ? FontAwesomeIcons.columns
                                : FontAwesomeIcons.thLarge,
                            color: colorPrimary,
                            size: size.height <= 569 ? 16 : 20),
                        SizedBox(width: 5),
                        Text(
                          grid ? 'Weekly View' : "Monthly View",
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 600 ? 11 : 13),
                        )
                      ],
                    )),
                PopupMenuItem(
                    value: 4,
                    child: Row(
                      children: <Widget>[
                        FaIcon(FontAwesomeIcons.search,
                            color: colorPrimary,
                            size: size.height <= 569 ? 16 : 20),
                        SizedBox(width: 5),
                        Text(
                          'Search',
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 600 ? 11 : 13),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
        body: BlocBuilder<MeetingBloc, MeetingState>(builder: (context, state) {
          if (state is MeetingStateSuccessLoad) {
            return Stack(
              children: [
                grid
                    ? Container(
                        margin: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: CalendarWidget(
                                  fontSize:
                                      size.height <= 600 ? textSizeSmall16 : 16,
                                  onSelectDate: (date, absence) {
                                    selectDate(date);
                                  },
                                  // data: List of `attendance model`,
                                  size: size,
                                ),
                              ),
                              SizedBox(height: 30),
                              TitleDayFormatted(
                                currentDate: _selectedDate,
                              ),
                              Container(
                                width: size.width,
                                child: isLoading
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 5,
                                        itemBuilder: (context, index) =>
                                            SkeletonLess3WithAvatar(
                                                size: size, row: 2))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.meetings.length,
                                        itemBuilder: (context, index) =>
                                            ScheduleItem(
                                          size: size,
                                          title: state.meetings[index].title,
                                          time1: util.hourFormat(
                                              state.meetings[index].date),
                                          time2: util.hourFormat(state
                                              .meetings[index].meetingEndTime),
                                          onClick: () {
                                            if (_controller.isDismissed) {
                                              setState(() {
                                                meetingID = state
                                                    .meetings[index].meetingID;
                                              });
                                              _meetingBloc.add(
                                                  LoadDetailMeetingEvent(
                                                      meetingID: meetingID));
                                              _controller.forward();
                                            } else if (_controller.isCompleted)
                                              _controller.reverse();
                                          },
                                        ),
                                      ),
                              )
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
                              fontSize:
                                  size.height <= 569 ? textSizeSmall14 : 16,
                              onSelectDate: (date) {
                                selectDate(date);
                              },
                            ),
                          ),
                          Expanded(
                              child: Container(
                            width: size.width,
                            child: isLoading
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) =>
                                        SkeletonLess3WithAvatar(
                                            size: size, row: 2))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.meetings.length,
                                    itemBuilder: (context, index) =>
                                        ScheduleItem(
                                      size: size,
                                      title: state.meetings[index].title,
                                      time1: util.hourFormat(
                                          state.meetings[index].date),
                                      time2: util.hourFormat(
                                          state.meetings[index].meetingEndTime),
                                      onClick: () {
                                        if (_controller.isDismissed) {
                                          setState(() {
                                            meetingID =
                                                state.meetings[index].meetingID;
                                          });
                                          _meetingBloc.add(
                                              LoadDetailMeetingEvent(
                                                  meetingID: meetingID));
                                          _controller.forward();
                                        } else if (_controller.isCompleted)
                                          _controller.reverse();
                                      },
                                    ),
                                  ),
                          ))
                        ],
                      )),
                showDraggableSheet(size),
              ],
            );
          } else if (state is MeetingStateFailLoad) {
            return Text("GetData Error");
          } else {
            return Text("GetData Error Waiting");
          }
        }));
  }

  // Dragabble Scroll sheet
  Widget showDraggableSheet(Size size) {
    return BlocBuilder<MeetingBloc, MeetingState>(builder: (context, state) {
      if (state is MeetingStateDetailSuccessLoad) {
        return SizedBox.expand(
          child: SlideTransition(
            position: _tween.animate(_controller),
            child: Container(
              child: DraggableScrollableSheet(
                maxChildSize: 0.8,
                initialChildSize: 0.8,
                minChildSize: 0.6,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                                              avatarRadius:
                                                  size.height <= 570 ? 15 : 20,
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
                                        fontSize: size.height <= 570 ? 18 : 20,
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
                                      setState(() {
                                        removeBackgroundDialog =
                                            !removeBackgroundDialog;
                                      });
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
        );
      } else if (state is MeetingStateLoading) {
        return Text("Loading....");
      } else {
        return Text("Not Yet");
      }
    });
  }
}
