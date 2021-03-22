import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/component/schedule/schedule-item-request.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

class SearchSchedule extends StatefulWidget {
  @override
  _SearchScheduleState createState() => _SearchScheduleState();
}

class _SearchScheduleState extends State<SearchSchedule> {
  TextEditingController textSearch = TextEditingController();
  String searchQuery = "";
  List<ScheduleModel> items = [];
  Util util = Util();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MeetingBloc>(context).add(LoadAllMeetingEvent());
  }

  //to search List
  void searchFunction(String q) {
    setState(() {
      searchQuery = q;
    });
  }

  /*void filterShowResult(MeetingStateSuccessLoad state) {
    if (textSearch.text == "" || textSearch.text == null || searchQuery == "") {
      setState(() {
        items.addAll(state.meetings);
      });
    } else {
      List<ScheduleModel> temp = [];
      state.meetings.forEach((element) {
        if (element.title.contains(searchQuery)) {
          temp.add(element);
        }
      });
      setState(() {
        items.clear();
        items.addAll(temp);
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        title: Text(
          "Search",
          style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
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
      body: Column(
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
          })
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
                    /*if (_controller.isDismissed) {
                                            _controller.forward();
                                            setState(() {
                                              model = state.meetings[index];
                                            });
                                          } else if (_controller.isCompleted)
                                            _controller.reverse();*/
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
                      /*if (_controller.isDismissed) {
                                            _controller.forward();
                                            setState(() {
                                              model = state.meetings[index];
                                            });
                                          } else if (_controller.isCompleted)
                                            _controller.reverse();*/
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
}
