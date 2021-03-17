import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';


abstract class LeaveTypeState extends Equatable {
  const LeaveTypeState();

  List<Object> get props => [];
}

class LeaveTypeStateLoading extends LeaveTypeState {}

class LeaveTypeStateFailLoad extends LeaveTypeState {}

class LeaveTypeStateSuccessLoad extends LeaveTypeState {
  final List<LeaveTypeModel> leaveType;
  // handle for checklist user
  

  LeaveTypeStateSuccessLoad({this.leaveType});

  List<Object> get props => [leaveType];

  @override
  String toString() {
    return 'Data : { employee List: $leaveType }';
  }
}
