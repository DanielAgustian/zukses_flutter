import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';


abstract class TaskPriorityLowState extends Equatable {
  const TaskPriorityLowState();

  List<Object> get props => [];
}

class TaskPriorityLowStateLoading extends TaskPriorityLowState {}

class TaskPriorityLowStateFailLoad extends TaskPriorityLowState {}

class TaskPriorityLowStateSuccessLoad extends TaskPriorityLowState {
  final List<TaskModel> task;
  // handle for checklist user
  

  TaskPriorityLowStateSuccessLoad({this.task});

  List<Object> get props => [task];

  @override
  String toString() {
    return 'Data : { employee List: $task }';
  }
}
