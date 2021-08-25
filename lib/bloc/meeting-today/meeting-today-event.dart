import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingTodayEvent extends Equatable {
  const MeetingTodayEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllMeetingTodayEvent extends MeetingTodayEvent {
  LoadAllMeetingTodayEvent();
  List<Object> get props => [];
}


class MeetingTodayEventDidUpdated extends MeetingTodayEvent {
  final List<ScheduleModel> schedule;
  const MeetingTodayEventDidUpdated(this.schedule);

  @override
  List<Object> get props => [schedule];
}