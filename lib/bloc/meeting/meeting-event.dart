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
  final String token;
  LoadAllMeetingEvent({this.token});
  List<Object> get props => [];
}

class LoadDetailMeetingEvent extends MeetingEvent {
  final String meetingID;

  LoadDetailMeetingEvent({this.meetingID});
  List<Object> get props => [];
}

class MeetingEventDidUpdated extends MeetingEvent {
  final List<ScheduleModel> meeting;
  const MeetingEventDidUpdated(this.meeting);

  @override
  List<Object> get props => [meeting];
}

//To delete meeting
class DeleteMeetingEvent extends MeetingEvent {
  final String meetingID;
  DeleteMeetingEvent({this.meetingID});
  List<Object> get props => [meetingID];
}

class UpdateMeetingEvent extends MeetingEvent {
  final String meetingID;
  final ScheduleModel model;
  UpdateMeetingEvent({this.meetingID, this.model});
  List<Object> get props => [meetingID];
}

class GetUnresponseMeetingEvent extends MeetingEvent {
  final List<ScheduleModel> meeting;
  GetUnresponseMeetingEvent({this.meeting});

  @override
  List<Object> get props => [meeting];
}

class GetAcceptedMeetingEvent extends MeetingEvent {
  final List<ScheduleModel> meeting;
  GetAcceptedMeetingEvent({this.meeting});

  @override
  List<Object> get props => [meeting];
}

class GetRejectedMeetingEvent extends MeetingEvent {
  final List<ScheduleModel> meeting;
  GetRejectedMeetingEvent({this.meeting});

  @override
  List<Object> get props => [meeting];
}

class PostAcceptanceMeetingEvent extends MeetingEvent {
  final String meetingId, accept, reason;
  PostAcceptanceMeetingEvent({this.meetingId, this.accept, this.reason});

  @override
  List<Object> get props => [meetingId, accept, reason];
}
