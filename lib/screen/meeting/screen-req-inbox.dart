import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/button/button-small-outlined.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/component/schedule/user-assigned-item.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/util/util.dart';

class RequestInbox extends StatefulWidget {
  final bool animate;

  const RequestInbox({Key key, this.animate}) : super(key: key);
  @override
  _RequestInboxState createState() => _RequestInboxState();
}

class _RequestInboxState extends State<RequestInbox>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<int> requestSchedule = [0, 0];
  bool loadingData = true;
  Util util = Util();
  final _textReasonReject = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
    BlocProvider.of<MeetingRejBloc>(context).add(LoadAllMeetingRejEvent());
    tabController = TabController(length: 2, vsync: this);
    if (widget.animate != null) {
      tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        bodyTab(context, size),
        loadingData ? loadingTab(context, size) : Container()
      ],
    );
  }

  //Widget for Loading Tab
  Widget loadingTab(BuildContext context, Size size) {
    return Container(
        height: size.height,
        width: size.width,
        color: Colors.black38.withOpacity(0.5),
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: colorPrimary70,
            // strokeWidth: 0,
            valueColor: AlwaysStoppedAnimation(colorBackground),
          ),
        ));
  }

  //Widget for Body
  Widget bodyTab(BuildContext context, Size size) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Request",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 569 ? 18 : 22,
              color: colorPrimary),
        ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => (ScreenTab(index: 3))));
          },
        ),
      ),
      body: Stack(
        children: [
          MultiBlocListener(listeners: listeners(), child: Container()),
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: colorBackground,
              appBar: AppBar(
                backgroundColor: colorBackground,
                automaticallyImplyLeading: false,
                elevation: 0,
                flexibleSpace: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: colorNeutral150,
                      borderRadius: BorderRadius.circular(5)),
                  child: TabBar(
                    controller: tabController,
                    labelColor: colorBackground,
                    unselectedLabelColor: colorPrimary,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    indicator: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(5)),
                    tabs: [
                      Tab(
                        child: Container(
                          child: Stack(
                            children: [
                              Center(
                                child: Text("waiting_text").tr(),
                              ),
                              positionedDot(context, size, requestSchedule[0])
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Stack(
                            children: [
                              Center(
                                child: Text("rejected_text").tr(),
                              ),
                              positionedDot(context, size, requestSchedule[1])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  requestWaiting(context, size),
                  requestReject(context, size)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //===============Listeners======================//
  List<BlocListener> listeners() => [
        BlocListener<MeetingReqBloc, MeetingReqState>(
          listener: (context, state) {
            if (state is MeetingReqStateSuccessLoad) {
              setState(() {
                loadingData = false;
                requestSchedule[0] = state.schedule.length;
              });
            } else if (state is MeetingReqStateLoading) {
              setState(() {
                loadingData = true;
              });
            } else if (state is MeetingReqStateFailLoad) {
              setState(() {
                loadingData = false;
                requestSchedule[0] = 0;
              });
            }
          },
        ),
        BlocListener<MeetingBloc, MeetingState>(
          listener: (context, state) {
            if (state is MeetingStateSuccess) {
              setState(() {
                loadingData = true;
              });
              BlocProvider.of<MeetingReqBloc>(context)
                  .add(LoadAllMeetingReqEvent());
              BlocProvider.of<MeetingRejBloc>(context)
                  .add(LoadAllMeetingRejEvent());
            } else if (state is MeetingStateLoading) {
              setState(() {
                loadingData = true;
              });
            } else if (state is MeetingStateFailLoad) {
              setState(() {
                loadingData = false;
                //requestSchedule[1] = 0;
              });
            }
          },
        ),
        BlocListener<MeetingRejBloc, MeetingRejState>(
          listener: (context, state) {
            if (state is MeetingRejStateSuccessLoad) {
              setState(() {
                loadingData = false;

                requestSchedule[1] = state.meetings.length;
              });
            } else if (state is MeetingRejStateFailLoad) {
              setState(() {
                loadingData = false;
                requestSchedule[1] = 0;
              });
            }
          },
        ),
      ];

  //-----------------Widget for Tab Waiting------------------------//

  Widget requestWaiting(BuildContext context, Size size) {
    return BlocBuilder<MeetingReqBloc, MeetingReqState>(
        builder: (context, state) {
      List<ScheduleModel> meetings;

      if (state is MeetingReqStateSuccessLoad) {
        meetings = state.schedule;
      } else if (state is MeetingReqStateFailLoad) {
        return Center(
          child: Text(
            "No Meeting Request.",
            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
          ),
        );
      }
      return meetings == null || meetings.length == 0
          ? Center(
              child: Text(
                "No Meeting Request.",
                style:
                    TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
              ),
            )
          : Stack(
              children: [
                Container(
                    child: ListView.builder(
                        itemCount: meetings.length,
                        itemBuilder: (context, index) => ScheduleItemRequest(
                            listMember: meetings[index].members,
                            count: meetings[index].members.length,
                            date:
                                util.dateNumbertoCalendar(meetings[index].date),
                            size: size,
                            onClick: () {
                              showModalResultWaiting(size,
                                  model: meetings[index]);
                            },
                            time1: util.hourFormat(meetings[index].date),
                            time2:
                                util.hourFormat(meetings[index].meetingEndTime),
                            title: meetings[index].title))),
                /*shade
                        ? Container(
                            width: size.width,
                            height: size.height,
                            color: Colors.black38.withOpacity(0.5),
                          )
                        : Container(),*/
              ],
            );
    });
  }

  Future<void> showModalResultWaiting(Size size, {ScheduleModel model}) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState2) {
            return DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                Navigator.pop(context);
                                /*setState(() {
                                  shade = false;
                                });*/
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
                      Text("schedule_text1".tr(),
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
                                imgUrl: model.members[index].imgUrl,
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
                        title: "accept_text".tr(),
                        onClick: () {
                          BlocProvider.of<MeetingBloc>(context).add(
                              PostAcceptanceMeetingEvent(
                                  meetingId: model.meetingID,
                                  accept: "1",
                                  reason: ""));
                          Navigator.pop(context);

                          //loadBeginningData();
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
                        title: "reject_text".tr(),
                        onClick: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _dialog(context, model: model));
                        },
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _dialog(BuildContext context, {ScheduleModel model}) {
    bool reasonReject = false;
    return AlertDialog(
      //title: const Text('Popup example'),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "schedule_text11".tr(),
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
              decoration: BoxDecoration(
                  color: colorBackground,
                  boxShadow: [
                    BoxShadow(
                      color: colorNeutral2.withOpacity(0.7),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                      color: reasonReject ? colorError : Colors.transparent)),
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
                    hintText: 'schedule_text14'.tr(),
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: reasonReject ? colorError : colorNeutral2)),
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
                    title: "cancel_text".tr(),
                    onClick: () {
                      Navigator.pop(context);
                      //loadBeginningData();
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SmallButtonOutlined(
                    bgColor: colorBackground,
                    textColor: colorPrimary,
                    borderColor: colorPrimary,
                    title: "confirm_text".tr(),
                    onClick: () {
                      if (_textReasonReject.text != "") {
                        BlocProvider.of<MeetingBloc>(context).add(
                            PostAcceptanceMeetingEvent(
                                meetingId: model.meetingID,
                                accept: "0",
                                reason: _textReasonReject.text));
                        setState(() => _textReasonReject.text = "");
                        Navigator.pop(context);
                      } else {
                        setState(() => reasonReject = true);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        );
      }),
      actions: <Widget>[],
    );
  }

  //---------------------------------------------------------------//

  //-------------Widget for Rejected Meeting REquest --------------//
  Widget requestReject(BuildContext context, Size size) {
    return BlocBuilder<MeetingRejBloc, MeetingRejState>(
        builder: (context, state) {
      if (state is MeetingRejStateSuccessLoad) {
        int panjang = state.meetings.length;
        return panjang >= 1
            ? Stack(
                children: [
                  Container(
                      child: ListView.builder(
                          itemCount: state.meetings.length,
                          itemBuilder: (context, index) => ScheduleItemRequest(
                              listMember: state.meetings[index].members,
                              count: state.meetings[index].members.length,
                              size: size,
                              onClick: () {
                                showModalResultRejected(size,
                                    model: state.meetings[index]);
                              },
                              date: util.dateNumbertoCalendar(
                                  state.meetings[index].date),
                              time1:
                                  util.hourFormat(state.meetings[index].date),
                              time2: util.hourFormat(
                                  state.meetings[index].meetingEndTime),
                              title: state.meetings[index].title))),
                ],
              )
            : Center(
                child: Text(
                  "No Meeting has been Rejected.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              );
      }
      return Container();
    });
  }

  Future<void> showModalResultRejected(Size size, {ScheduleModel model}) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState2) {
            return DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                Navigator.pop(context);
                                setState(() {
                                  //shade = false;
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
                      Text("schedule_text1".tr(),
                          style: TextStyle(
                              fontSize: 16,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700)),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          controller: scrollController,
                          itemCount: model.members.length,
                          itemBuilder: (BuildContext context, int index) {
                            return UserAssignedItem(
                                imgUrl: model.members[index].imgUrl,
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
                        title: "accept_text".tr(),
                        onClick: () {
                          BlocProvider.of<MeetingBloc>(context).add(
                              PostAcceptanceMeetingEvent(
                                  meetingId: model.meetingID,
                                  accept: "1",
                                  reason: ""));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget positionedDot(BuildContext context, Size size, int value) {
    return value < 1
        ? Container()
        : Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorSecondaryRed,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                        color: colorBackground,
                        fontSize: size.height < 569 ? 8 : 10),
                  ),
                ),
              ),
            ));
  }
}
