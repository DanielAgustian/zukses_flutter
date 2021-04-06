import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';
import 'package:zukses_app_1/model/schedule-model.dart';


abstract class MeetingReqState extends Equatable {
  const MeetingReqState();

  List<Object> get props => [];
}

class MeetingReqStateLoading extends MeetingReqState {}

class MeetingReqStateFailLoad extends MeetingReqState {}

class MeetingReqStateSuccessLoad extends MeetingReqState {
  final List<ScheduleModel> schedule;
  // handle for checklist user
  

  MeetingReqStateSuccessLoad({this.schedule});

  List<Object> get props => [schedule];

  @override
  String toString() {
    return 'Data : { employee List: $schedule }';
  }
}