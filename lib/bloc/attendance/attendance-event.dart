import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  List<Object> get props => [];
}

// User did clock in
class AttendanceClockIn extends AttendanceEvent {
  final File image;

  AttendanceClockIn({this.image});
  List<Object> get props => [image];
}

// User did clock out
class AttendanceClockOut extends AttendanceEvent {}

// Load all user attendance by month and year
class LoadUserAttendanceEvent extends AttendanceEvent {
  final DateTime date;

  LoadUserAttendanceEvent({this.date});
  List<Object> get props => [date];
}

// Usually used to updating data when there is any event
class AttendanceEventDidUpdated extends AttendanceEvent {
  final List<AttendanceModel> attendanceList;

  AttendanceEventDidUpdated({this.attendanceList});
  List<Object> get props => [attendanceList];
}
