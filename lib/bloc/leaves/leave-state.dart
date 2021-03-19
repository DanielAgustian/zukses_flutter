import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-model.dart'; 

abstract class LeaveState extends Equatable {
  const LeaveState();

  List<Object> get props => [];
}

//State for POST
class LeaveStateSuccess extends LeaveState {}

class LeaveStateFail extends LeaveState {}

//Universal State for Waiting Response
class LeaveStateLoading extends LeaveState {}

//State for Get
class LeaveStateFailLoad extends LeaveState {}

class LeaveStateSuccessLoad extends LeaveState {
  final List<LeaveModel> leave;
  // handle for checklist user

  LeaveStateSuccessLoad({this.leave});

  List<Object> get props => [leave];

  @override
  String toString() {
    return 'Data : { employee List: $leave }';
  }
}
