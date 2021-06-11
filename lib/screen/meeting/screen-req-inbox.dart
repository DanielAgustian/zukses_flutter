import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-event.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-state.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/meeting/screen-tab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/meeting/screen-tab2.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
    BlocProvider.of<MeetingBloc>(context).add(GetRejectedMeetingEvent());
    tabController = TabController(length: 2, vsync: this);
    if (widget.animate != null) {
      tabController.animateTo(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isLoading = false;
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => (ScreenTab(index: 3))));
          },
        ),
      ),
      body: Stack(
        children: [
          BlocListener<MeetingReqBloc, MeetingReqState>(
            listener: (context, state) {
              if (state is MeetingReqStateSuccessLoad) {
                isLoading = false;
                setState(() {
                  requestSchedule[0] = state.schedule.length;
                });
              } else if (state is MeetingReqStateLoading) {
                isLoading = true;
              }
            },
            child: Container(),
          ),
          BlocListener<MeetingBloc, MeetingState>(
            listener: (context, state) {
              if (state is MeetingStateSuccessLoad) {
                isLoading = false;
                setState(() {
                  requestSchedule[1] = state.meetings.length;
                });
              } else if (state is MeetingStateSuccess) {
                isLoading = false;
                BlocProvider.of<MeetingReqBloc>(context)
                    .add(LoadAllMeetingReqEvent());
                BlocProvider.of<MeetingBloc>(context)
                    .add(GetRejectedMeetingEvent());
              } else if (state is MeetingStateSuccess) {
                isLoading = true;
              }
            },
            child: Container(),
          ),
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
                  ScreenTabRequest(
                    loading: isLoading,
                    screen: "wait",
                  ),
                  ScreenTabRequest2(
                    loading: isLoading,
                    screen: "reject",
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
