import 'package:flutter/material.dart';
import 'package:zukses_app_1/util/util.dart';

class AttendanceModel {
  DateTime clockIn, clockOut;
  TimeOfDay officeStartTime, officeEndTime;
  String isLate, id;
  String overtime;
  AttendanceModel(
      {this.id,
      this.clockIn,
      this.clockOut,
      this.isLate,
      this.overtime,
      this.officeStartTime,
      this.officeEndTime});

  AttendanceModel.fromJson(Map<String, dynamic> map) {
    this.clockIn = DateTime.parse(map['clock_in_time']);
    this.clockOut = map['clock_out_time'] == null
        ? null
        : DateTime.parse(map['clock_out_time']);
    this.isLate = map['late'];
    this.id = map['id'].toString();
    this.overtime = map['minuteOvertime'] == null ? "" : map["minuteOvertime"];
  }
}
