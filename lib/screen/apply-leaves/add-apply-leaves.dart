import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/leave-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
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

  LeaveTypeModel result = LeaveTypeModel();
  List<LeaveTypeModel> dataLeaveType = [];

  List<String> items = [
    "apply_leaves_text4".tr(),
    "apply_leaves_text5".tr(),
    "apply_leaves_text6".tr()
  ];
  String repeat = "apply_leaves_text4".tr();
  String leaveType = "";
  bool isLoading = false;
  String project = "Agerabot";
  List<String> projectList = ["Agerabot", "WGM", "Bayer"];
  String task = "Front End";
  List<String> taskList = ["Front End", "Back End", "Design"];
  String dateDisplay = "";
  List<String> dateDisplayList = [];
  AttendanceModel user = AttendanceModel();
  List<AttendanceModel> userModel = [];
  String attendanceId = "";
  bool isLoading2 = false;

  @override
  void initState() {
    super.initState();
    if (widget.permission == "leaves") {
      BlocProvider.of<LeaveTypeBloc>(context).add(LoadAllLeaveTypeEvent());
    } else if (widget.permission == "overtime") {
      BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
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
            ? addApplyLeaves(size, context)
            : addOvertime(context));
  }

  Widget addApplyLeaves(Size size, BuildContext context) {
    return Scaffold(
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
                  "cancel_text".tr(),
                  style: TextStyle(
                      fontSize: size.height <= 600 ? 14 : 16,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
        title: Text(
          "apply_leaves_text1".tr(),
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
                },
                child: Container(
                  child: Text(
                    "done_text".tr(),
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
                        _gotoLeavesList();
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
                        ? "apply_leaves_text7".tr()
                        : "date_text".tr(),
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
                          title: "apply_leaves_text8".tr(),
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
                          title: "team_member_text1".tr(),
                          textItem: Util().changeTimeToString(startTime),
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
                          title: "team_member_text2".tr(),
                          textItem: Util().changeTimeToString(endTime),
                          fontSize: size.height <= 600 ? 14 : 16,
                        ),
                      )
                    : Container(),
                BlocListener<LeaveTypeBloc, LeaveTypeState>(
                  listener: (context, state) {
                    if (state is LeaveTypeStateSuccessLoad) {
                      dataLeaveType.clear();

                      setState(() {
                        dataLeaveType.addAll(state.leaveType);
                        result = dataLeaveType[0];
                        isLoading = true;
                      });
                    }
                  },
                  child: Container(),
                ),
                isLoading
                    ? AddScheduleLeaveType(
                        onSelectedItem: (val) {
                          setState(() {
                            result = val;
                          });
                          //_changeLeave();
                        },
                        items: dataLeaveType,
                        title: "apply_leaves_text3".tr(),
                        textItem: result,
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
                        hintText: "task_text20".tr(),
                        hintStyle: TextStyle(
                          color: _reasonValidator ? colorError : colorNeutral1,
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
    );
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
                          "schedule_text8".tr(),
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
                        title: "schedule_text9".tr(),
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
                        title: "schedule_text10".tr(),
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
                  "cancel_text".tr(),
                  style: TextStyle(
                      fontSize: size.height <= 600 ? 15 : 18,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
        title: Text(
          "apply_overtime_text1".tr(),
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 18 : 22),
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
                },
                child: Container(
                  child: Text(
                    "done_text".tr(),
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
                BlocListener<OvertimeBloc, OvertimeState>(
                  listener: (context, state) {
                    if (state is OvertimeStateSuccess) {
                      _gotoOvertimeList();
                    }
                  },
                  child: Container(),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, 0);
                  },
                  child: AddScheduleRow(
                    title: "date_text".tr(),
                    textItem: "${formater.format(startDate)}",
                    fontSize: size.height <= 600 ? 14 : 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    pickTime(context, 0);
                  },
                  child: AddScheduleRow(
                    title: "team_member_text1".tr(),
                    textItem: Util().changeTimeToString(startTime),
                    fontSize: size.height <= 600 ? 14 : 16,
                  ),
                ),
                InkWell(
                  onTap: () {
                    pickTime(context, 1);
                  },
                  child: AddScheduleRow(
                    title: "team_member_text2".tr(),
                    textItem: Util().changeTimeToString(endTime),
                    fontSize: size.height <= 600 ? 14 : 16,
                  ),
                ),
                BlocBuilder<ProjectBloc, ProjectState>(
                    builder: (context, state) {
                  if (state is ProjectStateSuccessLoad) {
                    ProjectModel firstProject = state.project[0];
                    return AddScheduleRowProject(
                        fontSize: size.height <= 600 ? 14 : 16,
                        title: "apply_overtime_text3".tr(),
                        project: firstProject,
                        projectList: state.project,
                        onSelectedItem: (val) {
                          setState(() {
                            firstProject = val;
                            project = firstProject.name;
                          });
                        });
                  }
                  return SizedBox(
                    height: 40,
                    width: size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),

                /*AddScheduleRow2(
                    fontSize: size.height <= 600 ? 14 : 16,
                    title: "apply_overtime_text4".tr(),
                    textItem: task,
                    items: taskList,
                    onSelectedItem: (val) {
                      setState(() {
                        task = val;
                      });
                    }),*/
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
                        hintText: "task_text20".tr(),
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

  // --------------------------Logic-----------------------------//

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
    }
  }

  _createOvertime() async {
    BlocProvider.of<OvertimeBloc>(context).add(AddOvertimeEvent(
        date: startDate,
        startTime: Util().changeTimeToString(startTime) + "",
        endTime: Util().changeTimeToString(endTime) + "",
        project: project,
        reason: textReason.text));
  }

  Future<void> _createLeaves() async {
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
        .add(AddLeaveEvent(leaveModel: sentLeave, leaveId: result.id));
  }

  Widget _buildCupertino({BuildContext context, String title}) {
    return new CupertinoAlertDialog(
      title: new Text(
        "apply_leaves_text16".tr() + " !",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: Text(
        title,
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "see_list_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ],
    );
  }

  _gotoOvertimeList() async {
    bool result = await showDialog(
        context: context,
        builder: (context) => _buildCupertino(
            context: context, title: "You successfully applied for Overtime"));

    if (result == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => (ScreenListLeaves(
                    permission: "overtime",
                    animate: true,
                  ))));
    } else if (result) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => (ScreenListLeaves(
                    permission: "overtime",
                    animate: true,
                  ))));
    }
  }

  _gotoLeavesList() async {
    bool result = await showDialog(
        context: context,
        builder: (context) =>
            _buildCupertino(context: context, title: "dialog_text1".tr()));
    if (result == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => (ScreenListLeaves(
                    permission: "leaves",
                    animate: true,
                  ))));
    } else {
      if (result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => (ScreenListLeaves(
                      permission: "leaves",
                      animate: true,
                    ))));
      }
    }
  }
}
