import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-event.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-state.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';

import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/button/button-small-outlined.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/component/schedule/user-assigned-item.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenTabRequest extends StatefulWidget {
  const ScreenTabRequest({Key key, this.screen, this.loading = true})
      : super(key: key);

  @override
  _ScreenTabRequestState createState() => _ScreenTabRequestState();

  final String screen;
  final bool loading;
}

class _ScreenTabRequestState extends State<ScreenTabRequest>
    with SingleTickerProviderStateMixin {
  TextEditingController _textReasonReject = TextEditingController();

  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  Util util = Util();
  ScheduleModel model = ScheduleModel();
  bool shade = false;
  bool isLoading = true;
  void timer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
    _controller = AnimationController(vsync: this, duration: _duration);
    timer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BlocBuilder<MeetingReqBloc, MeetingReqState>(builder: (context, state) {
          if (state is MeetingReqStateSuccessLoad) {
            int panjang = state.schedule.length;
            return panjang >= 1
                ? Stack(
                    children: [
                      Container(
                          child: isLoading
                              ? ListView.builder(
                                  itemCount: state.schedule.length,
                                  itemBuilder: (context, index) =>
                                      SkeletonLess3WithAvatar(
                                        size: size,
                                        row: 2,
                                      ))
                              : ListView.builder(
                                  itemCount: state.schedule.length,
                                  itemBuilder: (context, index) =>
                                      ScheduleItemRequest(
                                          count: state
                                              .schedule[index].members.length,
                                          date: util.dateNumbertoCalendar(
                                              state.schedule[index].date),
                                          size: size,
                                          onClick: () {
                                            if (_controller.isDismissed) {
                                              _controller.forward();
                                              setState(() {
                                                model = state.schedule[index];
                                                shade = true;
                                              });
                                            } else if (_controller
                                                .isCompleted) {
                                              _controller.reverse();
                                              setState(() {
                                                shade = false;
                                              });
                                            }
                                          },
                                          time1: util.hourFormat(
                                              state.schedule[index].date),
                                          time2: util.hourFormat(state
                                              .schedule[index].meetingEndTime),
                                          title: state.schedule[index].title))),
                      shade
                          ? Container(
                              width: size.width,
                              height: size.height,
                              color: Colors.black38.withOpacity(0.5),
                            )
                          : Container(),
                      scrollerSheet()
                    ],
                  )
                : Center(
                    child: Text(
                      "No Meeting Request.",
                      style: TextStyle(
                          color: colorPrimary, fontWeight: FontWeight.bold),
                    ),
                  );
          } else if (state is MeetingReqStateFailLoad) {
            return Center(
              child: Text(
                "No Meeting Request.",
                style:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
              ),
            );
          }
          return Container();
        }),
      ],
    );
  }

  void loadBeginningData() {
    BlocProvider.of<MeetingBloc>(context).add(GetUnresponseMeetingEvent());
  }

  Widget scrollerSheet() {
    Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
          maxChildSize: 0.9,
          initialChildSize: 0.8,
          minChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 15)],
                  color: colorBackground,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: FaIcon(
                            FontAwesomeIcons.times,
                            color: colorPrimary,
                          ),
                          onTap: () {
                            _controller.reverse();
                            setState(() {
                              shade = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(util.dateNumbertoCalendar(model.date),
                      style: TextStyle(
                        fontSize: 16,
                        color: colorNeutral2,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      util.hourFormat(model.date) +
                          " - " +
                          util.hourFormat(model.meetingEndTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: colorNeutral2,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.description,
                    style: TextStyle(
                        fontSize: 14,
                        color: colorPrimary,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Assigned To",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorPrimary,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: model.members.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserAssignedItem(
                            size: size,
                            name: model.members[index].name,
                            status: util.acceptancePrint(
                                model.members[index].accepted));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  LongButton(
                    size: size,
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    title: "Accept",
                    onClick: () {
                      BlocProvider.of<MeetingBloc>(context).add(
                          PostAcceptanceMeetingEvent(
                              meetingId: model.meetingID,
                              accept: "1",
                              reason: ""));
                      _controller.reverse();
                      setState(() {
                        shade = false;
                      });
                      loadBeginningData();
                    },
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
                    onClick: () {
                      _controller.reverse();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _dialog(context));
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Why are you rejecting the meeting?",
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(color: colorBackground, boxShadow: [
              BoxShadow(
                color: colorNeutral2.withOpacity(0.7),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
            width: double.infinity,
            child: TextFormField(
              controller: _textReasonReject,
              keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 6,
              decoration: new InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Reason..',
                  hintStyle: TextStyle(fontSize: 14, color: colorNeutral2)),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SmallButton(
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                  title: "Cancel",
                  onClick: () {
                    Navigator.pop(context);
                    loadBeginningData();
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                SmallButtonOutlined(
                  bgColor: colorBackground,
                  textColor: colorPrimary,
                  borderColor: colorPrimary,
                  title: "Confirm",
                  onClick: () {
                    BlocProvider.of<MeetingBloc>(context).add(
                        PostAcceptanceMeetingEvent(
                            meetingId: model.meetingID,
                            accept: "0",
                            reason: _textReasonReject.text));
                    Navigator.pop(context);
                    loadBeginningData();
                  },
                ),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[],
    );
  }
}
