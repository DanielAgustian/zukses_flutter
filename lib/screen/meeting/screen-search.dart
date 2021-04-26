import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/util/util.dart';

class SearchSchedule extends StatefulWidget {
  @override
  _SearchScheduleState createState() => _SearchScheduleState();
}

class _SearchScheduleState extends State<SearchSchedule>
    with SingleTickerProviderStateMixin {
  TextEditingController textSearch = TextEditingController();
  String searchQuery = "";
  List<ScheduleModel> items = [];
  ScheduleModel model = ScheduleModel();
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  Util util = Util();
  bool shade = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    BlocProvider.of<MeetingBloc>(context).add(LoadAllMeetingEvent());
  }

  //to search List
  void searchFunction(String q) {
    setState(() {
      searchQuery = q;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        title: Text(
          "Search",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height < 569 ? 18 : 20),
        ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: colorBackground,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: colorNeutral1,
                            blurRadius: 15),
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.streetAddress,
                    onChanged: (val) {
                      searchFunction(val);
                    },
                    controller: textSearch,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorNeutral3,
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: colorNeutral3,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
              ),
              BlocBuilder<MeetingBloc, MeetingState>(builder: (context, state) {
                if (state is MeetingStateSuccessLoad) {
                  return _filterMethod(state, searchQuery, size);
                } else {
                  return Container();
                }
              }),
            ],
          ),
          shade
              ? Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black38.withOpacity(0.5),
                )
              : Container(),
          model.meetingID != null
              ? showDraggableSheet(size, model)
              : Container()
        ],
      ),
    );
  }

  Widget _filterMethod(MeetingStateSuccessLoad state, String query, Size size) {
    return Expanded(
      child: ListView.builder(
          itemCount: state.meetings.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            //return (Text("DADADADADADAD"));
            if (textSearch.text == "" ||
                searchQuery == "" ||
                textSearch.text == null) {
              return ScheduleItemRequest(
                  size: size,
                  count: state.meetings[index].members.length,
                  date: util.yearFormat(state.meetings[index].date),
                  onClick: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    if (_controller.isDismissed) {
                      _controller.forward();
                      setState(() {
                        model = state.meetings[index];
                        shade = true;
                      });
                    } else if (_controller.isCompleted) {
                      _controller.reverse();
                      setState(() {
                        shade = false;
                      });
                    }
                  },
                  time1: util.hourFormat(state.meetings[index].date),
                  time2: util.hourFormat(state.meetings[index].meetingEndTime),
                  title: state.meetings[index].title);
            } else {
              if (state.meetings[index].title
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                return ScheduleItemRequest(
                    size: size,
                    count: state.meetings[index].members.length,
                    date: util.yearFormat(state.meetings[index].date),
                    onClick: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (_controller.isDismissed) {
                        _controller.forward();
                        setState(() {
                          model = state.meetings[index];
                          print(model.meetingID);
                        });
                      } else if (_controller.isCompleted) _controller.reverse();
                    },
                    time1: util.hourFormat(state.meetings[index].date),
                    time2:
                        util.hourFormat(state.meetings[index].meetingEndTime),
                    title: state.meetings[index].title);
              }
              return Container();
            }
          }),
    );
  }

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
                              Text(
                                scheduleModel.title == null
                                    ? "Schedule Not Get"
                                    : scheduleModel.title,
                                style: TextStyle(
                                    fontSize: size.height <= 570 ? 18 : 20,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w700),
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.reverse();
                                  setState(() {
                                    shade = false;
                                  });
                                },
                                child: FaIcon(FontAwesomeIcons.times,
                                    color: colorPrimary, size: 20),
                              ),
                            ],
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
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                            //controller: scrollController,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                scheduleModel.members.length,
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
                                                        dotSize:
                                                            size.height <= 570
                                                                ? 8
                                                                : 10,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "User " +
                                                            scheduleModel
                                                                .members[index]
                                                                .name +
                                                            " (" +
                                                            util.acceptancePrint(
                                                                scheduleModel
                                                                    .members[
                                                                        index]
                                                                    .accepted) +
                                                            ") ",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height <= 570
                                                                  ? 14
                                                                  : 16,
                                                          color: colorPrimary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: size.height < 569
                                                        ? 2
                                                        : 5,
                                                  )
                                                ],
                                              );
                                            }),
                                      )
                              ],
                            ),
                          ),
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
