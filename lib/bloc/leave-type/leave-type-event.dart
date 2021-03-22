import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

abstract class LeaveTypeEvent extends Equatable {
  const LeaveTypeEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllLeaveTypeEvent extends LeaveTypeEvent {
  LoadAllLeaveTypeEvent();
  List<Object> get props => [];
}

class LeaveTypeEventDidUpdated extends LeaveTypeEvent {
  final List<LeaveTypeModel> leaveType;
  const LeaveTypeEventDidUpdated(this.leaveType);

  @override
  List<Object> get props => [leaveType];
}