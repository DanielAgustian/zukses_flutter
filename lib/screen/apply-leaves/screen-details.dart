import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/leave-model.dart';
import 'package:zukses_app_1/model/overtime-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-contact-supervisor.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:easy_localization/easy_localization.dart';

class LeavesDetailScreen extends StatefulWidget {
  LeavesDetailScreen(
      {Key key,
      this.title,
      this.index,
      this.details,
      this.leave,
      this.overtime});
  final String title;
  final int index;
  final String details;
  final LeaveModel leave;
  final OvertimeModel overtime;
  @override
  _LeavesDetailScreenState createState() => _LeavesDetailScreenState();
}

class _LeavesDetailScreenState extends State<LeavesDetailScreen> {
  final textReason = TextEditingController();
  final textReasonRejected = TextEditingController();
  final textReason2 = TextEditingController();
  LeaveModel leaveModel = LeaveModel();
  OvertimeModel overtimeModel = OvertimeModel();
  Util util = Util();
  @override
  void initState() {
    super.initState();
    leaveModel = widget.leave;
    overtimeModel = widget.overtime;
    if (overtimeModel == null) {
      textReason2.text = leaveModel.reason;
      textReasonRejected.text = leaveModel.rejectReason;
    } else {
      textReason.text = overtimeModel.reason;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.details == null
        ? Container(
            child: Center(
              child: Text("Data Error"),
            ),
          )
        : widget.details == "overtime"
            ? overtimeDetails(context, size)
            : leavesDetails(context, size);
  }

  Widget overtimeDetails(BuildContext context, Size size) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenContactSupervisor()));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorBackground,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "back_text".tr(),
                  style: TextStyle(
                      fontSize: size.height <= 600 ? 14 : 16,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
        title: Text(
          "Overtime Details",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 22),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddScheduleRowStatus(
                title: "Status",
                textItem: overtimeModel.status,
              ),
              AddScheduleRowNonArrow(
                lowerOpacity: true,
                title: "date_text".tr(),
                textItem: util.dateNumbertoCalendar(overtimeModel.date),
              ),
              AddScheduleRowNonArrow(
                lowerOpacity: true,
                title: "apply_overtime_text2".tr(),
                textItem: util.cutTime(overtimeModel.startTime) +
                    " - " +
                    util.cutTime(
                        overtimeModel.endTime), //nanti get dari OvertimeModel
              ),
              AddScheduleRowNonArrow(
                title: "apply_overtime_text3".tr(),
                textItem: overtimeModel.project,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "apply_overtime_text5".tr(),
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: size.height < 569 ? 14 : 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 15,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  readOnly: true,
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textReason,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "task_text20".tr(),
                      hintStyle: TextStyle(
                        color: colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              overtimeModel.status == "rejected"
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height < 569 ? 15 : 20,
                          ),
                          LongButton(
                            size: size,
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenContactSupervisor()));
                            },
                            title: "apply_leaves_text13".tr(),
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                          ),
                          SizedBox(
                            height: size.height < 569 ? 5 : 10,
                          ),
                          LongButtonOutline(
                            size: size,
                            onClick: () {},
                            title: "apply_leaves_text14".tr(),
                            bgColor: colorBackground,
                            textColor: colorPrimary,
                            outlineColor: colorPrimary,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget leavesDetails(BuildContext context, Size size) {
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
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "back_text".tr(),
                  style: TextStyle(
                      fontSize: size.height <= 600 ? 14 : 16,
                      color: colorPrimary,
                      fontWeight: FontWeight.w500),
                ),
              )),
        ),
        title: Text(
          "Leaves Details",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 22),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddScheduleRowStatus(
                title: "Status",
                textItem: leaveModel.status,
              ),
              AddScheduleRowNonArrow(
                title: "date_text".tr(),
                textItem: util
                    .dateNumbertoCalendar(DateTime.parse(leaveModel.leaveDate)),
              ),
              AddScheduleRowNonArrow(
                title: "apply_overtime_text2".tr(),
                textItem: leaveModel.duration, //nanti get dari OvertimeModel
              ),
              datePeriod(context, size, leaveModel.duration, leaveModel),
              SizedBox(
                height: 15,
              ),
              Text(
                "apply_overtime_text5".tr(),
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: size.height < 569 ? 14 : 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 15,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  readOnly: true,
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textReason2,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "apply_overtime_text5".tr(),
                      hintStyle: TextStyle(
                        color: colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              leaveModel.status == "rejected"
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height < 569 ? 15 : 20,
                          ),
                          /*Text(
                            "apply_leaves_text18".tr(),
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 569 ? 14 : 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                color: colorBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorNeutral1.withOpacity(1),
                                    blurRadius: 15,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              readOnly: true,
                              maxLines: 8,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              onChanged: (val) {},
                              controller: textReasonRejected,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                  hintText: "apply_leaves_text18".tr(),
                                  hintStyle: TextStyle(
                                    color: colorNeutral1,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: size.height < 569 ? 15 : 20,
                          ),*/
                          LongButton(
                            size: size,
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenContactSupervisor()));
                            },
                            title: "apply_leaves_text13".tr(),
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                          ),
                          SizedBox(
                            height: size.height < 569 ? 5 : 10,
                          ),
                          LongButtonOutline(
                            size: size,
                            onClick: () {},
                            title: "apply_leaves_text14".tr(),
                            bgColor: colorBackground,
                            textColor: colorPrimary,
                            outlineColor: colorPrimary,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget datePeriod(
      BuildContext context, Size size, String duration, LeaveModel leave) {
    switch (duration) {
      case "Half Day":
        return AddScheduleRowNonArrow(
          lowerOpacity: true,
          title: "hours_text".tr(),
          textItem: Util().cutTime(leaveModel.startTime) +
              "-" +
              Util().cutTime(leaveModel.endTime), //nanti get dari OvertimeModel
        );
        break;
      case "Multiple Day":
        return AddScheduleRowNonArrow(
            lowerOpacity: true,
            title: "Period",
            textItem: Util().dateNumbertoCalendar(
                    DateTime.parse(leaveModel.leaveDate)) +
                "-" //+
            //Util().dateNumbertoCalendar(DateTime.parse(leaveModel.leaveDateEnd)), //nanti get dari OvertimeModel
            );
        break;
      default:
        return Container();
        break;
    }
  }
}
