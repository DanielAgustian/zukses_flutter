import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingEvent extends Equatable {
  const MeetingEvent();

  List<Object> get props => [];
}

// Add meeting data
class AddMeetingEvent extends MeetingEvent {
  final ScheduleModel model;
  AddMeetingEvent({this.model});
  List<Object> get props => [model];
}

// Load all Meeting data
class LoadAllMeetingEvent extends MeetingEvent {
  // get meeting data by user id ? or token ?
  final String id;
  LoadAllMeetingEvent({this.id});
  List<Object> get props => [];
}

class MeetingEventDidUpdated extends MeetingEvent {
  final List<ScheduleModel> meeting;
  const MeetingEventDidUpdated(this.meeting);

  @override
  List<Object> get props => [meeting];
}
