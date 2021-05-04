import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/bloc/employee/employee-bloc.dart';
import 'package:zukses_app_1/bloc/employee/employee-event.dart';
import 'package:zukses_app_1/bloc/employee/employee-state.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/schedule/user-invitation-item.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textTitle = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  bool _titleValidator = false;
  bool _descriptionValidator = false;
  bool _timeValidator = false;
  // Search controlerr
  TextEditingController textSearch = new TextEditingController();
  String searchQuery = "";

  // formater for showing date
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  DateTime date = DateTime.now();
  TimeOfDay time1 = TimeOfDay.now();
  TimeOfDay time2;
  List<UserModel> listUser = [];
  List<String> choosedUser = [];

  // time 1 and time 2
  DateTime startMeeting;
  DateTime endMeeting;

  // Dropdown menu
  List<String> items = [
    "Never",
    "Everyday",
    "Weekly",
    "Every Two Weeks",
    "Every Year"
  ];
  String repeat = "Never";

  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  //INIT Employee BLOC
  EmployeeBloc _employeeBloc;

  // Search Function
  void searchFunction(String q) {
    setState(() {
      searchQuery = q;
    });
  }

  // Handle if user click back using button in device not in app (usually for android)
  Future<bool> _onWillPop({size}) async {
    return (await showDialog(
            context: context,
            barrierColor: Colors.white.withOpacity(0.5),
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          "Are you sure you want to discard your changes ?",
                          style: TextStyle(color: colorPrimary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButton(
                        size: size,
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        title: "Keep Editing",
                        onClick: () {
                          Navigator.of(context, rootNavigator: true).pop();
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
                        title: "Discard Changes",
                        onClick: () {
                          Navigator.pop(context, true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      (ScreenTab(index: 3))));
                        },
                      )
                    ],
                  ),
                ),
              );
            })) ??
        false;
  }

// get calendar function
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(3500),
    );
    if (picked != null && picked != date)
      setState(() {
        date = picked;
      });
  }

  // pick time function (MUST PICKED. NOT PICKING MAKE IT CANT BE ADDED)
  void pickTime(BuildContext context, {int index = 1}) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: index == 1 ? time1 : time2,
    );
    try {
      if (picked.minute == 60) {
        picked = TimeOfDay(hour: picked.hour + 1, minute: 0);
      }
    } catch (error) {
      print(error);
    }

    if (picked != null) {
      setState(() {
        if (index == 1) {
          time1 = picked;
          time2 = TimeOfDay(hour: time1.hour, minute: time1.minute + 30);
        } else {
          time2 = picked;
        }

        startMeeting =
            DateTime(date.year, date.month, date.day, time1.hour, time1.minute);
        endMeeting =
            DateTime(date.year, date.month, date.day, time2.hour, time2.minute);
      });
    }
  }

  void addMeeting() {
    if (textTitle.text == "") {
      setState(() {
        _titleValidator = true;
      });
    } else {
      setState(() {
        _titleValidator = false;
      });
    }
    if (textDescription.text == "") {
      setState(() {
        _descriptionValidator = true;
      });
    } else {
      setState(() {
        _descriptionValidator = false;
      });
    }
    int pembanding =
        (time2.hour * 60 + time2.minute) - (time1.hour * 60 + time1.minute);
    if (pembanding < 0) {
      setState(() {
        _timeValidator = true;
      });
    } else {
      setState(() {
        _timeValidator = false;
      });
    }
    if (startMeeting != null) if (!_descriptionValidator &&
        !_titleValidator &&
        startMeeting != null &&
        endMeeting != null &&
        !_timeValidator) {
      ScheduleModel meeting = ScheduleModel(
          title: textTitle.text,
          description: textDescription.text,
          date: startMeeting,
          meetingEndTime: endMeeting,
          repeat: repeat.toLowerCase(),
          userID: choosedUser);

      // call event to add meeting
      BlocProvider.of<MeetingBloc>(context)
          .add(AddMeetingEvent(model: meeting));
    }
  }

  @override
  void initState() {
    super.initState();

    // getListUser();
    // init employee bloc
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeBloc.add(LoadAllEmployeeEvent());

    _controller = AnimationController(vsync: this, duration: _duration);
    
    // Handle view of `time2` on condition auto set 30 minutes after `time1`
    // if hour = 24, tjhen it should be 00
    // and if minutes = 60, it should be 00
    int h, m;
    m = time1.minute >= 30 ? (time1.minute + 30) - 60 : (time1.minute + 30);
    h = time1.minute >= 30
        ? time1.hour >= 23
            ? 00
            : time1.hour + 1
        : time1.hour;

    time2 = TimeOfDay(hour: h, minute: m);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // formater to split the hours,
    // eg. avoid when 01.01 => 1.1
    // It should be 01.01
    String h1 = (time1.hour <= 9) ? "0${time1.hour}" : time1.hour.toString();
    String m1 =
        (time1.minute <= 9) ? "0${time1.minute}" : time1.minute.toString();
    String h2 = (time2.hour <= 9) ? "0${time2.hour}" : time2.hour.toString();
    String m2 =
        (time2.minute <= 9) ? "0${time2.minute}" : time2.minute.toString();

    return WillPopScope(
      onWillPop: () {
        if (textDescription.text != "" || textTitle.text != "")
          return _onWillPop(size: size);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorPrimary,
            ),
            onPressed: () {
              if (textDescription.text != "" || textTitle.text != "")
                _onWillPop(size: size);
              else
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            (ScreenTab(index: 3))));
            },
          ),
          centerTitle: true,
          title: Text(
            "Add Schedule",
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 18 : 22),
          ),
          actions: [
            Center(
              child: InkWell(
                onTap: addMeeting,
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: size.height <= 569 ? 15 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: colorBackground,
        body: Stack(
          children: [
            // Listener for success add meeting
            BlocListener<MeetingBloc, MeetingState>(
              listener: (context, state) {
                if (state is MeetingStateSuccess) {
                  Navigator.pop(context, true);
                } else if (state is MeetingStateFail) {
                  Util().showToast(
                      msg: "Something Wrong !",
                      color: colorError,
                      context: this.context,
                      txtColor: colorBackground);
                }
              },
              child: Container(),
            ),
            //

            Padding(
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              child: Container(
                color: colorBackground,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: _titleValidator
                                  ? Border.all(color: colorError)
                                  : Border.all(color: Colors.transparent),
                              color: colorBackground,
                              boxShadow: [boxShadowStandard],
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.streetAddress,
                            onChanged: (val) {},
                            controller: textTitle,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  color: _titleValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        child: Container(
                          decoration: BoxDecoration(
                              border: _descriptionValidator
                                  ? Border.all(color: colorError)
                                  : Border.all(color: Colors.transparent),
                              color: colorBackground,
                              boxShadow: [boxShadowStandard],
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            maxLines: 8,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textDescription,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                hintText: "Description",
                                hintStyle: TextStyle(
                                  color: _descriptionValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }

                                _selectDate(this.context);
                              },
                              child: AddScheduleRow(
                                fontSize: size.height <= 569 ? 14 : 16,
                                title: "Date",
                                textItem: "${formater.format(date)}",
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                pickTime(this.context, index: 2);
                                pickTime(this.context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: colorBackground,
                                    border: Border.all(
                                        color: _timeValidator
                                            ? colorError
                                            : colorBackground)),
                                child: AddScheduleRow(
                                  fontSize: size.height <= 569 ? 14 : 16,
                                  title: "Time",
                                  textItem: "$h1.$m1 - $h2.$m2",
                                ),
                              ),
                            ),

                            AddScheduleRow2(
                              fontSize: size.height <= 569 ? 14 : 16,
                              title: "Repeat",
                              textItem: repeat,
                              items: items,
                              onSelectedItem: (val) {
                                setState(() {
                                  repeat = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Invite",
                                style: TextStyle(
                                    fontSize: size.height <= 569 ? 14 : 16,
                                    color: colorPrimary),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ////
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        child: LongButtonIcon(
                          size: size,
                          title: "Add Invitation",
                          bgColor: colorBackground,
                          textColor: colorPrimary,
                          iconWidget: FaIcon(
                            FontAwesomeIcons.plusCircle,
                            color: colorPrimary,
                          ),
                          onClick: () {
                            if (_controller.isDismissed)
                              _controller.forward();
                            else if (_controller.isCompleted)
                              _controller.reverse();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<EmployeeBloc, EmployeeState>(
                        builder: (context, state) {
                          if (state is EmployeeStateSuccessLoad) {
                            return Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: choosedUser.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                ),
                                itemBuilder: (context, index) {
                                  // If user has been choos attendance
                                  if (choosedUser.length != 0) {
                                    for (var i = 0;
                                        i < state.employees.length;
                                        i++) {
                                      if (state.employees[i].userID ==
                                          choosedUser[index]) {
                                        return Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  colorSecondaryRed,
                                              radius:
                                                  size.height <= 569 ? 20 : 30,
                                            ),
                                            Text(
                                              "${state.employees[i].name}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colorPrimary,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  }
                                  return SizedBox();
                                },
                              ),
                            );
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            scrollerSheet(),
          ],
        ),
      ),
    );
  }

  // Scroller invvitation function
  Widget scrollerSheet() {
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
          maxChildSize: 0.8,
          initialChildSize: 0.7,
          minChildSize: 0.4,
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _controller.reverse();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height < 600
                                  ? 14
                                  : 16,
                              color: colorPrimary),
                        ),
                      ),
                      Text(
                        "Add Invitation",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height < 600
                                ? 18
                                : 20,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          _controller.reverse();
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height < 600
                                  ? 14
                                  : 16,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(240, 239, 242, 1),
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
                            color: colorNeutral1,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: colorNeutral1,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<EmployeeBloc, EmployeeState>(
                    builder: (context, state) {
                      if (state is EmployeeStateSuccessLoad) {
                        return showMember(scrollController, state,
                            query: searchQuery);
                      } else {}
                      return Container();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // List to show the member
  Widget showMember(
      ScrollController scrollController, EmployeeStateSuccessLoad state,
      {String query}) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: state.employees.length,
        itemBuilder: (BuildContext context, int index) {
          if (textSearch.text == "" || textSearch.text == null) {
            return UserInvitationItem(
              val: state.checklist[index],
              title: state.employees[index].name,
              checkboxCallback: (val) {
                setState(() {
                  state.checklist[index] = !state.checklist[index];

                  // If user is checked, add to list choosed User
                  if (state.checklist[index]) {
                    choosedUser.add(state.employees[index].userID);

                    // If uncheck, remove from the list
                  } else {
                    choosedUser.remove(state.employees[index].userID);
                  }
                });
              },
            );
          } else {
            // Handle for search function
            if (state.employees[index].name
                .toLowerCase()
                .contains(query.toLowerCase())) {
              return UserInvitationItem(
                val: state.checklist[index],
                title: state.employees[index].name,
                checkboxCallback: (val) {
                  setState(() {
                    state.checklist[index] = !state.checklist[index];

                    // If user is checked, add to list choosed User
                    if (state.checklist[index]) {
                      choosedUser.add(state.employees[index].userID);

                      // If uncheck, remove from the list
                    } else {
                      choosedUser.remove(state.employees[index].userID);
                    }
                  });
                },
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}
