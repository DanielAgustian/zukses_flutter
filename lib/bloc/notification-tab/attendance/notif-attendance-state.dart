import 'package:equatable/equatable.dart';

abstract class NotificationAttendanceState extends Equatable {
  const NotificationAttendanceState();

  List<Object> get props => [];
}

class NotificationAttendanceStateFailed extends NotificationAttendanceState {}

class NotificationAttendanceStateSuccess extends NotificationAttendanceState {}

class NotificationAttendanceStateLoading extends NotificationAttendanceState {}
