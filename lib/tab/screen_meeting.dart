import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
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
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/util/util.dart';

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key, this.title, this.meetingId}) : super(key: key);
  final String title;
  final String meetingId;
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate;

  List<ScheduleModel> meetings;
  final textSearch = TextEditingController();

  int week;
  DateTime _currentDate = DateTime.now();
  bool grid = true;
  bool removeBackgroundDialog = false;
  bool isVisible = true;

  //STRING FOR GLOBAL VARIABLE
  String meetingID;
  int waitingRequest = 0;
  List<String> date1 = [], date2 = [];

  Util util = Util();
  MeetingBloc _meetingBloc;

  bool loading = false;
  bool searching = false;
  String myId = '';
  @override
  void initState() {
    super.initState();
    getMeetingReq();
    _getMyID();
    BlocProvider.of<MeetingSearchBloc>(context)
        .add(LoadAllMeetingSearchEvent());
    _meetingBloc = BlocProvider.of<MeetingBloc>(context);
    _meetingBloc.add(GetAcceptedMeetingEvent(
        month: _currentDate.month, year: _currentDate.year));
    _selectedDate = _currentDate;
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
          title: Container(
            height: 30,
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: colorNeutral2)),
            child: TextField(
              controller: textSearch,
              onChanged: (val) {
                if (val.length > 0) {
                  setState(() {
                    searching = true;
                    isVisible = false;
                  });
                } else {
                  setState(() {
                    searching = false;
                    isVisible = true;
                  });
                }
              },
              style: TextStyle(color: Colors.black, fontSize: 16, height: 1.1),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 6),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FaIcon(FontAwesomeIcons.search,
                      color: colorNeutral2, size: size.height < 569 ? 14 : 16),
                ),
                suffixIcon: InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: FaIcon(FontAwesomeIcons.times,
                        color: colorNeutral2,
                        size: size.height < 569 ? 14 : 16),
                  ),
                  onTap: () {
                    setState(() {
                      textSearch.text = "";
                      searching = false;
                      isVisible = true;
                    });
                  },
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: colorNeutral2),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RequestInbox()));
                },
                child: Stack(
                  children: [
                    Center(
                      child: FaIcon(FontAwesomeIcons.solidBell,
                          color: colorPrimary,
                          size: size.height <= 569 ? 18 : 22),
                    ),
                    BlocBuilder<MeetingReqBloc, MeetingReqState>(
                        builder: (context, state) {
                      if (state is MeetingReqStateSuccessLoad) {
                        if (state.schedule.length < 1) {
                          return Container();
                        } else {
                          return Positioned(
                            right: 0,
                            top: 10,
                            //padding: EdgeInsets.fromLTRB(35, 0, 0, 10),
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: colorError,
                                shape: BoxShape.circle,
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
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    grid = !grid;
                  });
                },
                child: Center(
                  child: FaIcon(
                      grid
                          ? FontAwesomeIcons.columns
                          : FontAwesomeIcons.thLarge,
                      color: colorPrimary,
                      size: size.height <= 569 ? 18 : 22),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: isVisible,
          child: FloatingActionButton(
            child:
                FaIcon(FontAwesomeIcons.plus, size: 25, color: colorBackground),
            onPressed: () {
              _getPopAddScreen();
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: RefreshIndicator(
              color: colorPrimary,
              strokeWidth: 1,
              onRefresh: refreshData,
              child: searching
                  ? searchingData(context, size)
                  : buildMainBody(size)),
        ));
  }

  // Build the main body
  Widget buildMainBody(Size size) {
    return BlocListener<MeetingBloc, MeetingState>(
      listener: (context, state) {
        setState(() {
          if (state is MeetingStateSuccessLoad) {
            loading = false;
            meetings = state.meetings;
          } else if (state is MeetingStateFailLoad) {
            loading = false;
          } else if (state is MeetingStateSuccess) {
            loading = false;
            // _meetingBloc.add(GetAcceptedMeetingEvent(
            //     month: _currentDate.month, year: _currentDate.year));
          } else if (state is MeetingStateLoading) {
            loading = true;
          }
        });
      },
      child: Stack(
        children: [
          grid ? buildViewGrid(size) : buildViewList(size),
        ],
      ),
    );
  }

  // Build view with list version calendar
  Widget buildViewList(Size size) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width,
            height:
                size.height <= 569 ? size.height * 0.21 : size.height * 0.17,
            child: CalendarListWidget(
              fontSize: size.height <= 569 ? textSizeSmall14 : 16,
              onSelectDate: (date) {
                selectDate(date);
              },
              data: meetings,
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
                showMeetingList(size)
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // Build view with grid version calendar
  Widget buildViewGrid(Size size) {
    return Container(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: CalendarWidget(
                  fontSize: size.height <= 600 ? textSizeSmall16 : 16,
                  data: meetings,
                  size: size,
                  onSelectDate: (date, absence) {
                    selectDate(date);
                  },
                  onClickToggle: (DateTime val) {
                    _meetingBloc.add(GetAcceptedMeetingEvent(
                        month: val.month, year: val.year));
                  },
                ),
              ),
              SizedBox(height: 30),
              TitleDayFormatted(
                currentDate: _selectedDate,
              ),
              SizedBox(
                height: 5,
              ),
              showMeetingList(size)
            ],
          ),
        ));
  }

  // Show the meeting list of the day
  Widget showMeetingList(Size size) {
    return Container(
      width: size.width,
      child: loading
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) =>
                  SkeletonLess3WithAvatar(size: size, row: 2))
          : meetings == null
              ? Container()
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: meetings.length,
                  itemBuilder: (context, index) => util
                              .yearFormat(_selectedDate) ==
                          util.yearFormat(meetings[index].date)
                      ? ScheduleItem(
                          members: meetings[index].members,
                          count: meetings[index].members.length,
                          size: size,
                          title: meetings[index].title,
                          time1: util.hourFormat(meetings[index].date),
                          time2:
                              util.hourFormat(meetings[index].meetingEndTime),
                          onClick: () {
                            showModalResult(size, meetings[index]);
                          },
                        )
                      : Container()),
    );
  }

  // Show modal detail
  Future<void> showModalResult(Size size, ScheduleModel scheduleModel,
      {bool editable = true}) {
    String time1 = util.hourFormat(scheduleModel.date);
    String time2 = util.hourFormat(scheduleModel.meetingEndTime != null
        ? scheduleModel.meetingEndTime
        : scheduleModel.date);
    bool showmore = false;
    print("Id on Meeting:" + scheduleModel.makerId);
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0.1),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return DraggableScrollableSheet(
              maxChildSize: 0.8,
              initialChildSize: 0.8,
              minChildSize: 0.6,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("close_text".tr(),
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          myId == scheduleModel.makerId
                              ? InkWell(
                                  onTap: () {
                                    //Edit place
                                    _gotoEditScreen(scheduleModel);
                                  },
                                  child: Text(
                                    "edit_text".tr(),
                                    style: TextStyle(
                                        color: colorPrimary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
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
                        "schedule_text1".tr(),
                        style: TextStyle(
                            fontSize: size.height <= 570 ? 12 : 14,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      scheduleModel.members == null
                          ? Text("Empty")
                          : Expanded(
                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: countShowItem(
                                      members: scheduleModel.members,
                                      show: showmore),
                                  itemBuilder: (context, index) {
                                    // if assigned people more than 5
                                    // and it is the last man or index number 4
                                    // and [show more] button not clicked yet
                                    if (scheduleModel.members.length > 5 &&
                                        !showmore &&
                                        index == 4) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          assignedUserIteminModal(size,
                                              schedule: scheduleModel,
                                              index: index),
                                          TextButton(
                                              onPressed: () {
                                                setStateModal(() {
                                                  showmore = !showmore;
                                                });
                                              },
                                              child: Text(
                                                "Show more",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: size.height <= 570
                                                      ? 12
                                                      : 14,
                                                  color: colorPrimary,
                                                ),
                                              )),
                                        ],
                                      );
                                    }

                                    return assignedUserIteminModal(size,
                                        schedule: scheduleModel, index: index);
                                  }),
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

  // user item in modal
  Widget assignedUserIteminModal(Size size,
      {@required ScheduleModel schedule, @required int index}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          UserAvatarScheduleBigger(
            imgURL:
                "https://api-zukses.yokesen.com/${schedule.members[index].imgUrl}",
            status: util.acceptancePrint(schedule.members[index].accepted),
            avatarRadius: size.height <= 570 ? 15 : 25,
            dotSize: size.height <= 570 ? 8 : 10,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            schedule.members[index].name +
                " (" +
                util.acceptancePrint(schedule.members[index].accepted) +
                ") ",
            style: TextStyle(
              fontSize: size.height <= 570 ? 14 : 16,
              color: colorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Search view
  Widget searchingData(BuildContext context, Size size) {
    return Stack(
      children: [
        Column(
          children: [
            BlocBuilder<MeetingSearchBloc, MeetingSearchState>(
                builder: (context, state) {
              if (state is MeetingSearchStateSuccessLoad) {
                return _filterMethod(state.meeting, textSearch.text, size);
              } else {
                return Container();
              }
            }),
          ],
        ),
      ],
    );
  }

  // Did a filter data
  Widget _filterMethod(List<ScheduleModel> meetings, String query, Size size) {
    return Expanded(
      child: ListView.builder(
          itemCount: meetings.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            //return (Text("DADADADADADAD"));
            if (textSearch.text == "" || textSearch.text == null) {
              return ScheduleItemRequest(
                  listMember: meetings[index].members,
                  size: size,
                  count: meetings[index].members.length,
                  date: util.yearFormat(meetings[index].date),
                  onClick: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    showModalResult(size, meetings[index]);
                  },
                  time1: util.hourFormat(meetings[index].date),
                  time2: util.hourFormat(meetings[index].meetingEndTime),
                  title: meetings[index].title);
            } else {
              if (meetings[index]
                  .title
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                return ScheduleItemRequest(
                    size: size,
                    listMember: meetings[index].members,
                    count: meetings[index].members.length,
                    date: util.yearFormat(meetings[index].date),
                    onClick: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      showModalResult(size, meetings[index]);
                    },
                    time1: util.hourFormat(meetings[index].date),
                    time2: util.hourFormat(meetings[index].meetingEndTime),
                    title: meetings[index].title);
              }
              return Container();
            }
          }),
    );
  }

  // --------------------------Logic-----------------------------//
  // Logic to limit the showed member in detail meeting modal
  int countShowItem({@required List<UserModel> members, @required bool show}) {
    int total = members.length;
    if (total <= 4) {
      return total;
    } else {
      return show ? total : 5;
    }
  }

  Future<void> refreshData() async {
    DateTime _currentDate = DateTime.now();
    getMeetingReq();
    BlocProvider.of<MeetingSearchBloc>(context)
        .add(LoadAllMeetingSearchEvent());
    _meetingBloc = BlocProvider.of<MeetingBloc>(context);
    _meetingBloc.add(GetAcceptedMeetingEvent(
        month: _currentDate.month, year: _currentDate.year));
    _selectedDate = _currentDate;
  }

  _getMyID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = prefs.getString('myID');
    
  }

  void getMeetingReq() async {
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
  }

  _getPopAddScreen() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScheduleScreen()),
    );
    if (result != null) {
      if (result == true) {
        refreshData();
      }
    }
  }

  _gotoEditScreen(ScheduleModel scheduleModel) async {
    setState(() {
      isVisible = true;
    });
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditScheduleScreen(model: scheduleModel)));
    if (result != null) {
      if (result == true) {
        refreshData();
      }
    }
  }

  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenTab(
                  index: 0,
                )));
    return false;
  }

  void selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }
}
