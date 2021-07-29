import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskPriorityLowEvent extends Equatable {
  const TaskPriorityLowEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadLowPriorityEvent extends TaskPriorityLowEvent {
  final String priority;
  LoadLowPriorityEvent(this.priority);
  List<Object> get props => [];
}

class TaskPriorityLowEventDidUpdated extends TaskPriorityLowEvent {
  final List<TaskModel> leaveType;
  const TaskPriorityLowEventDidUpdated(this.leaveType);

  @override
  List<Object> get props => [leaveType];
}
