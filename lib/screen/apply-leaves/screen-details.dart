import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/leave-model.dart';
import 'package:zukses_app_1/model/overtime-model.dart';
import 'package:zukses_app_1/util/util.dart';

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
                  "Cancel",
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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
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
                title: "Date",
                textItem: util.dateNumbertoCalendar(overtimeModel.clockIn),
              ),
              AddScheduleRowNonArrow(
                title: "Duration",
                textItem: "00:00", //nanti get dari OvertimeModel
              ),
              AddScheduleRowNonArrow(
                title: "Project",
                textItem: overtimeModel.project,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Reason",
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
                      hintText: "Description",
                      hintStyle: TextStyle(
                        color: colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height < 569 ? 15 : 20,
                    ),
                    LongButton(
                      size: size,
                      onClick: () {},
                      title: "Contact Supervisor",
                      bgColor: colorPrimary,
                      textColor: colorBackground,
                    ),
                    SizedBox(
                      height: size.height < 569 ? 5 : 10,
                    ),
                    LongButtonOutline(
                      size: size,
                      onClick: () {},
                      title: "Re-Submit",
                      bgColor: colorBackground,
                      textColor: colorPrimary,
                      outlineColor: colorPrimary,
                    ),
                  ],
                ),
              )
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
                  "Cancel",
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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {},
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
                title: "Date",
                textItem: util
                    .dateNumbertoCalendar(DateTime.parse(leaveModel.leaveDate)),
              ),
              AddScheduleRowNonArrow(
                title: "Duration",
                textItem: leaveModel.duration, //nanti get dari OvertimeModel
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Reason",
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
                      hintText: "Reason",
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
                          LongButton(
                            size: size,
                            onClick: () {},
                            title: "Contact Supervisor",
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                          ),
                          SizedBox(
                            height: size.height < 569 ? 5 : 10,
                          ),
                          LongButtonOutline(
                            size: size,
                            onClick: () {},
                            title: "Re-Submit",
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
}
