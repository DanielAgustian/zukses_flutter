import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-event.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-state.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';
import 'package:zukses_app_1/module/calendar-list-widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/title-date-formated.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/screen/meeting/screen-edit-schedule.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';
import 'package:zukses_app_1/component/schedule/schedule-item.dart';
import 'package:zukses_app_1/screen/meeting/screen-add-schedule.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';
import 'package:zukses_app_1/screen/meeting/screen-search.dart';
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
  ScheduleModel scheduleClick = ScheduleModel();
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
  int waitingRequest = 0;
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
    getMeetingReq();
    //scheduleClick.title = "";
    _meetingBloc = BlocProvider.of<MeetingBloc>(context);
    _meetingBloc.add(GetAcceptedMeetingEvent());
    _selectedDate = _currentDate;

    util = Util();
    _controller = AnimationController(vsync: this, duration: _duration);
    timer();
  }

  void getMeetingReq() async {
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
  }

  _getPopAddScreen() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScheduleScreen()),
    );
    if(result!=null){
      if (result == true) {
      getMeetingReq();
    }
    }
    
  }

  _getPopSearchScreen() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchSchedule()));
    if (result != null) {
      if (result == true) {
        _meetingBloc = BlocProvider.of<MeetingBloc>(context);
        _meetingBloc.add(GetAcceptedMeetingEvent());
      }
    }
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
                fontSize: size.height <= 569 ? 18 : 22),
          ),
          actions: [
            PopupMenuButton(
              elevation: 5,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.ellipsisH,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                  BlocBuilder<MeetingReqBloc, MeetingReqState>(
                      builder: (context, state) {
                    if (state is MeetingReqStateSuccessLoad) {
                      if (state.schedule.length < 1) {
                        return Container();
                      } else {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(35, 0, 0, 10),
                            child: Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: colorError,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onSelected: (val) {
                switch (val) {

                  // Move to add schedule screen
                  case 1:
                    _getPopAddScreen();
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
                    _getPopSearchScreen();

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
                          BlocBuilder<MeetingReqBloc, MeetingReqState>(
                              builder: (context, state) {
                            if (state is MeetingReqStateSuccessLoad) {
                              waitingRequest = state.schedule.length;
                              return Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: colorSecondaryRed),
                                  child: Center(
                                    child: Text(
                                      state.schedule.length.toString(),
                                      style: TextStyle(
                                          color: colorBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height < 600 ? 8 : 10),
                                    ),
                                  ));
                            } else {
                              return Container();
                            }
                          })
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
                                  data: state.meetings,
                                  size: size,
                                ),
                              ),
                              SizedBox(height: 30),
                              TitleDayFormatted(
                                currentDate: _selectedDate,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: size.width,
                                child: isLoading
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.meetings.length,
                                        itemBuilder: (context, index) =>
                                            SkeletonLess3WithAvatar(
                                                size: size, row: 2))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.meetings.length,
                                        itemBuilder: (context, index) => util
                                                    .yearFormat(
                                                        _selectedDate) ==
                                                util.yearFormat(
                                                    state.meetings[index].date)
                                            ? ScheduleItem(
                                                count: state.meetings[index]
                                                    .members.length,
                                                size: size,
                                                title:
                                                    state.meetings[index].title,
                                                time1: util.hourFormat(
                                                    state.meetings[index].date),
                                                time2: util.hourFormat(state
                                                    .meetings[index]
                                                    .meetingEndTime),
                                                meetingId: state
                                                    .meetings[index].meetingID,
                                                onClick: () {
                                                  if (_controller.isDismissed) {
                                                    setState(() {
                                                      meetingID = state
                                                          .meetings[index]
                                                          .meetingID;
                                                      scheduleClick =
                                                          state.meetings[index];
                                                    });

                                                    _controller.forward();
                                                  } else if (_controller
                                                      .isCompleted)
                                                    _controller.reverse();
                                                },
                                              )
                                            : Container()),
                              )
                            ],
                          ),
                        ))
                    : Container(
                        child: SingleChildScrollView(
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
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: size.width,
                              height: size.height,
                              child: Column(
                                children: [
                                  TitleDayFormatted(
                                    currentDate: _selectedDate,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                      child: Container(
                                    width: size.width,
                                    child: isLoading
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.meetings.length,
                                            itemBuilder: (context, index) =>
                                                SkeletonLess3WithAvatar(
                                                    size: size, row: 2))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.meetings.length,
                                            itemBuilder: (context, index) =>
                                                util.yearFormat(
                                                            _selectedDate) ==
                                                        util.yearFormat(state
                                                            .meetings[index]
                                                            .date)
                                                    ? ScheduleItem(
                                                        count: state
                                                            .meetings[index]
                                                            .members
                                                            .length,
                                                        size: size,
                                                        title: state
                                                            .meetings[index]
                                                            .title,
                                                        time1: util.hourFormat(
                                                            state
                                                                .meetings[index]
                                                                .date),
                                                        time2: util.hourFormat(
                                                            state
                                                                .meetings[index]
                                                                .meetingEndTime),
                                                        onClick: () {
                                                          if (_controller
                                                              .isDismissed) {
                                                            setState(() {
                                                              meetingID = state
                                                                  .meetings[
                                                                      index]
                                                                  .meetingID;
                                                              scheduleClick =
                                                                  state.meetings[
                                                                      index];
                                                            });

                                                            _controller
                                                                .forward();
                                                          } else if (_controller
                                                              .isCompleted)
                                                            _controller
                                                                .reverse();
                                                        },
                                                      )
                                                    : Container()),
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                showDraggableSheet(size, scheduleClick),
              ],
            );
          } else if (state is MeetingStateFailLoad) {
            return Text("Get Data Error");
          } else if (state is MeetingStateSuccess) {
            _meetingBloc.add(GetAcceptedMeetingEvent());
            return Container();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }

  // Dragabble Scroll sheet
  Widget showDraggableSheet(Size size, ScheduleModel scheduleModel) {
    String time1 = util.hourFormat(scheduleModel.date);
    String time2 = util.hourFormat(scheduleModel.meetingEndTime != null
        ? scheduleModel.meetingEndTime
        : scheduleModel.date);

    return scheduleModel == null
        ? Container()
        : SizedBox.expand(
            child: SlideTransition(
              position: _tween.animate(_controller),
              child: Container(
                child: DraggableScrollableSheet(
                  maxChildSize: 0.8,
                  initialChildSize: 0.8,
                  minChildSize: 0.6,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          boxShadow: [BoxShadow(blurRadius: 15)],
                          color: colorBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /**/
                              InkWell(
                                onTap: () {
                                  _controller.reverse();
                                  setState(() {
                                    removeBackgroundDialog =
                                        !removeBackgroundDialog;
                                  });
                                },
                                child: Text("Close",
                                    style: TextStyle(
                                        color: colorPrimary,
                                        fontWeight: FontWeight.bold)),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditScheduleScreen(
                                                  model: scheduleModel)));
                                },
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height < 569 ? 3 : 5,
                          ),
                          Text(
                            scheduleModel.title == null
                                ? "Schedule Not Get"
                                : scheduleModel.title,
                            style: TextStyle(
                                fontSize: size.height <= 570 ? 18 : 20,
                                color: colorPrimary,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: size.height < 569 ? 2 : 5,
                          ),
                          Text(
                            "$time1 - $time2",
                            style: TextStyle(
                              fontSize: size.height <= 570 ? 12 : 14,
                              color: colorPrimary50,
                            ),
                          ),
                          SizedBox(
                            height: size.height <= 570 ? 6 : 10,
                          ),
                          Container(
                            width: size.width,
                            child: Text(
                              scheduleModel.description,
                              style: TextStyle(
                                fontSize: size.height <= 570 ? 12 : 14,
                                color: colorPrimary,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height <= 570 ? 10 : 15,
                          ),
                          Text(
                            "Assigned to",
                            style: TextStyle(
                                fontSize: size.height <= 570 ? 12 : 14,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          scheduleModel.members == null
                              ? Text("Data Null")
                              : Container(
                                  height: 0.3 * size.height,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: scheduleModel.members.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                UserAvatar(
                                                  avatarRadius:
                                                      size.height <= 570
                                                          ? 15
                                                          : 20,
                                                  dotSize: size.height <= 570
                                                      ? 8
                                                      : 10,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "User " +
                                                      scheduleModel
                                                          .members[index].name +
                                                      " (" +
                                                      util.acceptancePrint(
                                                          scheduleModel
                                                              .members[index]
                                                              .accepted) +
                                                      ") ",
                                                  style: TextStyle(
                                                    fontSize: size.height <= 570
                                                        ? 14
                                                        : 16,
                                                    color: colorPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height < 569 ? 2 : 5,
                                            )
                                          ],
                                        );
                                      }),
                                )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }
}
