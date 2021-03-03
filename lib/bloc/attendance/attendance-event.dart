import 'dart:io';

import 'package:equatable/equatable.dart';
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

// Usually used when there is change in data
class AttendanceEventDidUpdated extends AttendanceEvent {}
