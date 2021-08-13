import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingRejEvent extends Equatable {
  const MeetingRejEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllMeetingRejEvent extends MeetingRejEvent {
  LoadAllMeetingRejEvent();
  List<Object> get props => [];
}


class MeetingRejEventDidUpdated extends MeetingRejEvent {
  final List<ScheduleModel> schedule;
  const MeetingRejEventDidUpdated(this.schedule);

  @override
  List<Object> get props => [schedule];
}