import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:zukses_app_1/model/auth-model.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  List<Object> get props => [];
}

// Handle state loading
class AttendanceStateLoading extends AttendanceState {}

// Handle state user success clock in
class AttendanceStateSuccessClockIn extends AttendanceState {}

// Handle state user success clock out
class AttendanceStateSuccessClockOut extends AttendanceState {}

// Handle state user fail to clock in or out
class AttendanceStateFailed extends AttendanceState {}

// Handle failed load all attendance user
class AttendanceStateFailLoad extends AttendanceState {}

// Handle Success load all attendance user []
class AttendanceStateSuccessLoad extends AttendanceState {
  // save list of attendance user
  final List<AttendanceModel> attendanceList;

  AttendanceStateSuccessLoad({this.attendanceList});
  List<Object> get props => [attendanceList];
}
