import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/schedule-model.dart';

abstract class MeetingRejState extends Equatable {
  const MeetingRejState();

  List<Object> get props => [];
}

class MeetingRejStateLoading extends MeetingRejState {}

class MeetingRejStateFailLoad extends MeetingRejState {}

class MeetingRejStateSuccessLoad extends MeetingRejState {
  final List<ScheduleModel> meetings;
  // handle for checklist user

  MeetingRejStateSuccessLoad({this.meetings});

  List<Object> get props => [meetings];

  @override
  String toString() {
    return 'Data : { employee List: $meetings }';
  }
}
