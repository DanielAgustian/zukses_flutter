import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/component/schedule/user-assigned-item.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenTabRequest2 extends StatefulWidget {
  const ScreenTabRequest2({Key key, this.screen, this.loading = true})
      : super(key: key);

  @override
  _ScreenTabRequest2State createState() => _ScreenTabRequest2State();

  final String screen;
  final bool loading;
}

class _ScreenTabRequest2State extends State<ScreenTabRequest2>
    with SingleTickerProviderStateMixin {
  ScheduleModel model = ScheduleModel();
  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  Util util = Util();
  bool shade = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<MeetingBloc>(context).add(GetRejectedMeetingEvent());
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<MeetingBloc, MeetingState>(builder: (context, state) {
      if (state is MeetingStateSuccessLoad) {
        return Stack(
          children: [
            Container(
                child: widget.loading
                    ? ListView.builder(
                        itemCount: state.meetings.length,
                        itemBuilder: (context, index) =>
                            SkeletonLess3WithAvatar(
                              size: size,
                              row: 2,
                            ))
                    : ListView.builder(
                        itemCount: state.meetings.length,
                        itemBuilder: (context, index) => ScheduleItemRequest(
                            count: state.meetings[index].members.length,
                            size: size,
                            onClick: () {
                              if (_controller.isDismissed) {
                                _controller.forward();
                                setState(() {
                                  model = state.meetings[index];
                                  shade = true;
                                });
                              } else if (_controller.isCompleted) {
                                _controller.reverse();
                                shade = false;
                              }
                            },
                            date: util.dateNumbertoCalendar(
                                state.meetings[index].date),
                            time1: util.hourFormat(state.meetings[index].date),
                            time2: util.hourFormat(
                                state.meetings[index].meetingEndTime),
                            title: state.meetings[index].title))),
            shade
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black38.withOpacity(0.5),
                  )
                : Container(),
            model != null
                ? scrollerSheet()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("data Error"),
                  )
          ],
        );
      } else {
        return Container();
      }
    });
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
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
