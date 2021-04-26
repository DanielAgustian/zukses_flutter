import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';


abstract class TaskPriorityState extends Equatable {
  const TaskPriorityState();

  List<Object> get props => [];
}

class TaskPriorityStateLoading extends TaskPriorityState {}

class TaskPriorityStateFailLoad extends TaskPriorityState {}

class TaskPriorityStateSuccessLoad extends TaskPriorityState {
  final List<TaskModel> task;
  // handle for checklist user
  

  TaskPriorityStateSuccessLoad({this.task});

  List<Object> get props => [task];

  @override
  String toString() {
    return 'Data : { employee List: $task }';
  }
}
