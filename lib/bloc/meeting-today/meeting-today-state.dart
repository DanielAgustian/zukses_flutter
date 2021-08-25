import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/schedule-model.dart';


abstract class MeetingTodayState extends Equatable {
  const MeetingTodayState();

  List<Object> get props => [];
}

class MeetingTodayStateLoading extends MeetingTodayState {}

class MeetingTodayStateFailLoad extends MeetingTodayState {}

class MeetingTodayStateSuccessLoad extends MeetingTodayState {
  final List<ScheduleModel> schedule;
  // handle for checklist user
  

  MeetingTodayStateSuccessLoad({this.schedule});

  List<Object> get props => [schedule];

  @override
  String toString() {
    return 'Data : { employee List: $schedule }';
  }
}