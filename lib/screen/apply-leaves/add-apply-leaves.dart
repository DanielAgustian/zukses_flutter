import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';

class ApplyLeavesFormScreen extends StatefulWidget {
  @override
  _ApplyLeavesFormScreenState createState() => _ApplyLeavesFormScreenState();
}

class _ApplyLeavesFormScreenState extends State<ApplyLeavesFormScreen> {
  // formater for showing date
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  // Text field controller
  TextEditingController textReason = new TextEditingController();
  bool _reasonValidator = false;

  // Dropdown menu
  List<String> itemsLeave = ["Never", "Seldom", "Often", "Always"];
  List<String> items = ["Single Day", "Multiple Day", "Half Day"];
  String repeat = "Single Day";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        // if user press back button on device not the app
        if (textReason.text != "") return _onWillPop(size: size);
        return Future.value(true);
      },
      child: Scaffold(
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
                        fontSize: size.height <= 569 ? 15 : 18,
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
                fontSize: size.height <= 569 ? 20 : 25),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontSize: size.height <= 569 ? 15 : 18,
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
          padding: EdgeInsets.all(20),
          //color: colorSecondaryYellow70,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //SizedBox(height: 20),
                  AddScheduleRow2(
                    fontSize: size.height <= 569 ? 14 : 16,
                    title: items[0],
                    textItem: repeat,
                    items: items,
                    onSelectedItem: (val) {
                      print(val);
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
                      title: repeat == "Multiple Day" ? "Start Date" : "Date",
                      textItem: "${formater.format(startDate)}",
                      fontSize: size.height <= 569 ? 14 : 16,
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
                            fontSize: size.height <= 569 ? 14 : 16,
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
                            textItem: "$startTime",
                            fontSize: size.height <= 569 ? 14 : 16,
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
                            textItem: "$endTime",
                            fontSize: size.height <= 569 ? 14 : 16,
                          ),
                        )
                      : Container(),
                  AddScheduleRow2(
                    items: itemsLeave,
                    title: "Leave Type",
                    textItem: "Never",
                    fontSize: size.height <= 569 ? 14 : 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: _reasonValidator
                            ? Border.all(color: colorError)
                            : Border.all(color: Colors.transparent),
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(240, 239, 242, 1),
                              blurRadius: 15),
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
                            color:
                                _reasonValidator ? colorError : colorNeutral1,
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
      ),
    );
  }

  // APP BAR
  Widget customAppBar(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () {
              if (textReason.text != "")
                _onWillPop(size: size);
              else
                Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                  fontSize: size.height <= 569 ? 15 : 18,
                  color: colorPrimary,
                  fontWeight: FontWeight.w500),
            )),
        Text(
          "Apply Leaves",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 569 ? 20 : 25),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            child: Text(
              "Done",
              style: TextStyle(
                  fontSize: size.height <= 569 ? 15 : 18,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
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
      initialTime: index == 0 ? TimeOfDay.now() : startTime,
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
}
