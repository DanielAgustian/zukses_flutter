import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskPriorityEvent extends Equatable {
  const TaskPriorityEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadHighPriorityEvent extends TaskPriorityEvent {
  final String priority;
  LoadHighPriorityEvent(this.priority);
  List<Object> get props => [];
}

class TaskPriorityEventDidUpdated extends TaskPriorityEvent {
  final List<TaskModel> leaveType;
  const TaskPriorityEventDidUpdated(this.leaveType);

  @override
  List<Object> get props => [leaveType];
}
