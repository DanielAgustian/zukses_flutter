import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/leave-model.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  List<Object> get props => [];
}

class AddLeaveEvent extends LeaveEvent {
  final LeaveModel leaveModel;
  final int leaveId;
  AddLeaveEvent({this.leaveModel, this.leaveId});
  List<Object> get props => [leaveModel];
}

// Load all leave data
class LoadAllLeaveEvent extends LeaveEvent {
  LoadAllLeaveEvent();
  List<Object> get props => [];
}

class LeaveEventDidUpdated extends LeaveEvent {
  final List<LeaveModel> leave;
  const LeaveEventDidUpdated(this.leave);

  @override
  List<Object> get props => [leave];
}
