import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingReqEvent extends Equatable {
  const MeetingReqEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllMeetingReqEvent extends MeetingReqEvent {
  LoadAllMeetingReqEvent();
  List<Object> get props => [];
}


class MeetingReqEventDidUpdated extends MeetingReqEvent {
  final List<ScheduleModel> schedule;
  const MeetingReqEventDidUpdated(this.schedule);

  @override
  List<Object> get props => [schedule];
}