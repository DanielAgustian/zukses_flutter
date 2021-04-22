import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingState extends Equatable {
  const MeetingState();

  List<Object> get props => [];
}

class MeetingStateLoading extends MeetingState {}

// Success to add, edit, delete, add state
class MeetingStateSuccess extends MeetingState {}

// Failed to add, edit, delete, add state
class MeetingStateFail extends MeetingState {}

class MeetingStateFailLoad extends MeetingState {}

class MeetingStateSuccessLoad extends MeetingState {
  final List<ScheduleModel> meetings;

  MeetingStateSuccessLoad({this.meetings});

  List<Object> get props => [meetings];

  @override
  String toString() {
    return 'Data : { Meeting List: $meetings }';
  }
}

class MeetingStateDetailSuccessLoad extends MeetingState {
  final ScheduleModel meeting;

  MeetingStateDetailSuccessLoad({this.meeting});

  List<Object> get props => [meeting];

  @override
  String toString() {
    return 'Data : { Meeting List: $meeting }';
  }
}

class MeetingStateUpdateSuccess extends MeetingState {}

class MeetingStateUpdateFailed extends MeetingState {}
