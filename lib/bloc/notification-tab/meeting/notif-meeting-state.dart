import 'package:equatable/equatable.dart';

abstract class NotificationMeetingState extends Equatable {
  const NotificationMeetingState();

  List<Object> get props => [];
}

class NotificationMeetingStateFailed extends NotificationMeetingState {}

class NotificationMeetingStateSuccess extends NotificationMeetingState {}

class NotificationMeetingStateLoading extends NotificationMeetingState {}
