import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/overtime-model.dart';

abstract class OvertimeEvent extends Equatable {
  const OvertimeEvent();

  List<Object> get props => [];
}

class AddOvertimeEvent extends OvertimeEvent {
  final DateTime date;
  final String startTime, endTime;
  final String reason, project;
  AddOvertimeEvent(
      {this.startTime, this.endTime, this.date, this.reason, this.project});
  List<Object> get props => [OvertimeModel];
}

// Load all Overtime data
class LoadAllOvertimeEvent extends OvertimeEvent {
  LoadAllOvertimeEvent();
  List<Object> get props => [];
}

class OvertimeEventDidUpdated extends OvertimeEvent {
  final List<OvertimeModel> overtime;
  const OvertimeEventDidUpdated(this.overtime);

  @override
  List<Object> get props => [overtime];
}
