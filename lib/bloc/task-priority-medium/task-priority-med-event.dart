import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskPriorityMedEvent extends Equatable {
  const TaskPriorityMedEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadMedPriorityEvent extends TaskPriorityMedEvent {
  final String priority;
  LoadMedPriorityEvent(this.priority);
  List<Object> get props => [];
}

class TaskPriorityMedEventDidUpdated extends TaskPriorityMedEvent {
  final List<TaskModel> leaveType;
  const TaskPriorityMedEventDidUpdated(this.leaveType);

  @override
  List<Object> get props => [leaveType];
}
