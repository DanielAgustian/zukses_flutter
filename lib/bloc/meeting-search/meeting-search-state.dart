import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/schedule-model.dart';


abstract class MeetingSearchState extends Equatable {
  const MeetingSearchState();

  List<Object> get props => [];
}

class MeetingSearchStateLoading extends MeetingSearchState {}

class MeetingSearchStateFailLoad extends MeetingSearchState {}

class MeetingSearchStateSuccessLoad extends MeetingSearchState {
  final List<ScheduleModel> meeting;
  // handle for checklist user
  

  MeetingSearchStateSuccessLoad({this.meeting});

  List<Object> get props => [meeting];

  @override
  String toString() {
    return 'Data : { employee List: $meeting }';
  }
}
