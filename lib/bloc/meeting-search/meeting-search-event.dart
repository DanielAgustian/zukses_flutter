import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingSearchEvent extends Equatable {
  const MeetingSearchEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllMeetingSearchEvent extends MeetingSearchEvent {
  LoadAllMeetingSearchEvent();
  List<Object> get props => [];
}

class MeetingSearchEventDidUpdated extends MeetingSearchEvent {
  final List<ScheduleModel> meeting;
  const MeetingSearchEventDidUpdated(this.meeting);

  @override
  List<Object> get props => [meeting];
}