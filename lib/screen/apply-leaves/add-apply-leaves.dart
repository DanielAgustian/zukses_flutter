import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-bloc.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-event.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-state.dart';
import 'package:zukses_app_1/bloc/leaves/leave-bloc.dart';
import 'package:zukses_app_1/bloc/leaves/leave-event.dart';
import 'package:zukses_app_1/bloc/leaves/leave-state.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-bloc.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/leave-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

class ApplyLeavesFormScreen extends StatefulWidget {
  ApplyLeavesFormScreen({Key key, this.title, this.index, this.permission});
  final String title;
  final int index;
  final String permission;
  @override
  _ApplyLeavesFormScreenState createState() => _ApplyLeavesFormScreenState();
}

class _ApplyLeavesFormScreenState extends State<ApplyLeavesFormScreen> {
  // formater for showing date
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 30);
  TimeOfDay endTime = TimeOfDay(hour: 12, minute: 0);
  int idLeaveType;
  // Text field controller
  TextEditingController textReason = new TextEditingController();
  bool _reasonValidator = false;
  String durationOvertime = "";
  // Dropdown menu
  List<String> itemsLeaveName = [];
  List<int> itemLeaveNameID = [];
  List<LeaveTypeModel> dataLeaveType = [];
  List<String> items = ["Single Day", "Multiple Day", "Half Day"];
  String repeat = "Single Day";
  String leaveType = "";
  bool isLoading = false;
  String project = "Agerabot";
  List<String> projectList = ["Agerabot", "WGM", "Bayer"];
  String task = "Front End";
  List<String> taskList = ["Front End", "Back End", "Design"];
  String dateDisplay = "";
  List<String> dateDisplayList = [];
  List<AttendanceModel> userModel = [];
  String attendanceId = "";
  bool isLoading2 = false;
  @override
  void initState() {
    super.initState();
    if (widget.permission == "leaves") {
      BlocProvider.of<LeaveTypeBloc>(context).add(LoadAllLeaveTypeEvent());
    } else if (widget.permission == "overtime") {
      BlocProvider.of<AttendanceBloc>(context)
          .add(LoadUserAttendanceEvent(date: DateTime.now()));
    } else {
      Util().showToast(
          txtColor: colorError,
          msg: "Permission error",
          duration: 3,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          // if user press back button on device not the app
          if (textReason.text != "") return _onWillPop(size: size);
          return Future.value(true);
        },
        child: widget.permission == "leaves"
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: colorBackground,
                  leadingWidth: 70,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                        onTap: () {
                          if (textReason.text != "")
                            _onWillPop(size: size);
                          else
                            Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: size.height <= 600 ? 14 : 16,
                                color: colorPrimary,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                  ),
                  title: Text(
                    "Apply Leaves",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height <= 600 ? 20 : 22),
                  ),
                  actions: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            _createLeaves();
                            //Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        (ScreenListLeaves(
                                            permission: "leaves"))));
                          },
                          child: Container(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  fontSize: size.height <= 600 ? 14 : 16,
                                  color: colorPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: colorBackground,
                body: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal, vertical: paddingVertical),
                  //color: colorSecondaryYellow70,
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BlocListener<LeaveBloc, LeaveState>(
                              listener: (context, state) {
                                if (state is LeaveStateSuccess) {
                                  Util().showToast(
                                      context: this.context,
                                      msg: "Leave Created",
                                      color: colorPrimary,
                                      txtColor: colorBackground);
                                } else if (state is LeaveStateFail) {
                                  Util().showToast(
                                      context: this.context,
                                      msg: "Something Wrong !",
                                      color: colorError,
                                      txtColor: colorBackground);
                                }
                              },
                              child: Container()),
                          //SizedBox(height: 20),
                          AddScheduleRow2(
                            fontSize: size.height <= 600 ? 14 : 16,
                            title: items[0],
                            textItem: repeat,
                            items: items,
                            onSelectedItem: (val) {
                              setState(() {
                                repeat = val;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              _selectDate(context, 0);
                            },
                            child: AddScheduleRow(
                              title: repeat == "Multiple Day"
                                  ? "Start Date"
                                  : "Date",
                              textItem: "${formater.format(startDate)}",
                              fontSize: size.height <= 600 ? 14 : 16,
                            ),
                          ),
                          repeat == "Multiple Day"
                              ? InkWell(
                                  onTap: () {
                                    _selectDate(context, 1);
                                  },
                                  child: AddScheduleRow(
                                    title: "End Date",
                                    textItem: "${formater.format(endDate)}",
                                    fontSize: size.height <= 600 ? 14 : 16,
                                  ),
                                )
                              : Container(),
                          repeat == "Half Day"
                              ? InkWell(
                                  onTap: () {
                                    pickTime(context, 0);
                                  },
                                  child: AddScheduleRow(
                                    title: "Start Time",
                                    textItem:
                                        Util().changeTimeToString(startTime),
                                    fontSize: size.height <= 600 ? 14 : 16,
                                  ),
                                )
                              : Container(),
                          repeat == "Half Day"
                              ? InkWell(
                                  onTap: () {
                                    pickTime(context, 1);
                                  },
                                  child: AddScheduleRow(
                                    title: "End Time",
                                    textItem:
                                        Util().changeTimeToString(endTime),
                                    fontSize: size.height <= 600 ? 14 : 16,
                                  ),
                                )
                              : Container(),
                          BlocListener<LeaveTypeBloc, LeaveTypeState>(
                            listener: (context, state) {
                              if (state is LeaveTypeStateSuccessLoad) {
                                itemsLeaveName.clear();
                                dataLeaveType.clear();
                                //itemLeaveNameID.clear();
                                int i = 0;
                                state.leaveType.forEach((element) {
                                  if (i < 1) {
                                    setState(() {
                                      leaveType = element.typeName;
                                      i++;
                                    });
                                  }
                                  setState(() {
                                    itemLeaveNameID.add(element.id);

                                    itemsLeaveName.add(element.typeName);
                                  });
                                });
                                setState(() {
                                  dataLeaveType.addAll(state.leaveType);
                                  isLoading = true;
                                });
                              }
                            },
                            child: Container(),
                          ),
                          isLoading
                              ? AddScheduleRow2(
                                  onSelectedItem: (val) {
                                    setState(() {
                                      leaveType = val;
                                    });
                                    _changeLeave();
                                  },
                                  items: itemsLeaveName,
                                  title: "Leave Type",
                                  textItem: leaveType,
                                  fontSize: size.height <= 600 ? 14 : 16,
                                )
                              : Container(),

                          Container(
                            decoration: BoxDecoration(
                                border: _reasonValidator
                                    ? Border.all(color: colorError)
                                    : Border.all(color: Colors.transparent),
                                color: colorBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorNeutral1.withOpacity(1),
                                    blurRadius: 15,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              maxLines: 8,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              onChanged: (val) {},
                              controller: textReason,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                    color: _reasonValidator
                                        ? colorError
                                        : colorNeutral1,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : addOvertime(context));
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
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              );
            })) ??
        false;
  }

  //Widget for Add Overtime Front
  Widget addOvertime(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(onPressed: () {
          temp();
        }),*/
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorBackground,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                if (textReason.text != "")
                  _onWillPop(size: size);
                else
                  Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: size.height <= 600 ? 15 : 18,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
        title: Text(
          "Apply Overtime",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 25),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  //_createLeaves();
                  _createOvertime();
                  //Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              (ScreenListLeaves(permission: "overtime"))));
                },
                child: Container(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: size.height <= 600 ? 15 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: colorBackground,
      body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          //color: colorSecondaryYellow70,
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocListener<AttendanceBloc, AttendanceState>(
                  listener: (context, state) {
                    if (state is AttendanceStateSuccessLoad) {
                      dateDisplayList.clear();
                      userModel.clear();
                      userModel.addAll(state.attendanceList);
                      int i = 0;
                      state.attendanceList.forEach((element) {
                        dateDisplayList.add(element.clockOut.toString());

                        if (i < 1) {
                          setState(() {
                            dateDisplay = element.clockOut.toString();
                          });
                          i++;
                        }
                      });
                      setState(() {
                        isLoading2 = true;
                      });
                    } else {}
                  },
                  child: Container(),
                ),
                isLoading2
                    ? AddScheduleRow2(
                        fontSize: size.height <= 569 ? 14 : 16,
                        title: "Date",
                        textItem:
                            dateDisplay, //"${formater.format(dateDisplay)}",
                        items: dateDisplayList,
                        onSelectedItem: (val) {
                          _changeDate();
                          setState(() {
                            dateDisplay = val;
                          });
                        })
                    : CircularProgressIndicator(),
                isLoading2
                    ? AddScheduleRow(
                        arrowRight: "false",
                        title: "Duration",
                        textItem: durationOvertime == ""
                            ? "00:00:00"
                            : durationOvertime,
                        fontSize: size.height <= 569 ? 14 : 16,
                      )
                    : CircularProgressIndicator(),
                AddScheduleRow2(
                    fontSize: size.height <= 600 ? 14 : 16,
                    title: "Project",
                    textItem: project,
                    items: projectList,
                    onSelectedItem: (val) {
                      setState(() {
                        project = val;
                      });
                    }),
                AddScheduleRow2(
                    fontSize: size.height <= 600 ? 14 : 16,
                    title: "Task",
                    textItem: task,
                    items: taskList,
                    onSelectedItem: (val) {
                      setState(() {
                        task = val;
                      });
                    }),
                Container(
                  decoration: BoxDecoration(
                      border: _reasonValidator
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
                    controller: textReason,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        hintText: "Description",
                        hintStyle: TextStyle(
                          color: _reasonValidator ? colorError : colorNeutral1,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  //Method to Pick Date
  _selectDate(BuildContext context, int choose) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(3500),
    );

    if (picked != null && picked != startDate && picked != endDate) {
      if (choose == 0) {
        setState(() {
          startDate = picked;
        });
      } else if (choose == 1) {
        setState(() {
          endDate = picked;
        });
      }
    }
  }

  //Method to PickTime.
  pickTime(BuildContext context, int index) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: index == 0 ? TimeOfDay(hour: 8, minute: 00) : startTime,
    );
    try {
      if (picked.minute == 60) {
        picked = TimeOfDay(hour: picked.hour + 1, minute: 0);
      }
    } catch (error) {
      print(error);
    }

    if (picked != null) {
      if (index == 0) {
        setState(() {
          startTime = picked;
        });
        //time2 = TimeOfDay(hour: time1.hour, minute: time1.minute + 30);
      } else if (index == 1) {
        setState(() {
          endTime = picked;
        });
      } else {
        print("GetDataError");
      }

      /*startMeeting =
            DateTime(date.year, date.month, date.day, time1.hour, time1.minute);
        endMeeting =
            DateTime(date.year, date.month, date.day, time2.hour, time2.minute);*/

    }
  }

  _changeLeave() {
    dataLeaveType.forEach((element) {
      if (element.typeName == leaveType) {
        setState(() {
          idLeaveType = element.id;
        });
      }
    });
  }

  _changeDate() {
    userModel.forEach((element) {
      if (element.clockOut.toString() == dateDisplay) {
        setState(() {
          attendanceId = element.id;
          durationOvertime = element.overtime == null ? "" : element.overtime;

          print("duration : " + durationOvertime);
        });
      }
    });
  }

  _createOvertime() {
    BlocProvider.of<OvertimeBloc>(context).add(AddOvertimeEvent(
        attendanceId: int.parse(attendanceId),
        project: project,
        reason: textReason.text));
  }

  void _createLeaves() {
    LeaveModel sentLeave = LeaveModel();
    if (repeat == items[0]) {
      //Duration: Single Day
      sentLeave = LeaveModel(
          duration: repeat,
          leaveDate: Util().yearFormat(startDate),
          startTime: "",
          endTime: "",
          leaveDateEnd: "",
          reason: textReason.text);
    } else if (repeat == items[1]) {
      //Duration: Multiple Day
      sentLeave = LeaveModel(
          duration: repeat,
          leaveDate: Util().yearFormat(startDate),
          startTime: "",
          endTime: "",
          leaveDateEnd: Util().yearFormat(endDate),
          reason: textReason.text);
    } else if (repeat == items[2]) {
      //Duration : Half Day
      sentLeave = LeaveModel(
          duration: repeat,
          leaveDate: Util().yearFormat(startDate),
          startTime: Util().changeTimeToString(startTime) + ":00",
          endTime: Util().changeTimeToString(endTime) + ":00",
          leaveDateEnd: "",
          reason: textReason.text);
    }

    BlocProvider.of<LeaveBloc>(context)
        .add(AddLeaveEvent(leaveModel: sentLeave, leaveId: idLeaveType));
  }
}
