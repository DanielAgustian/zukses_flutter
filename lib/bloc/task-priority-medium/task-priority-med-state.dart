import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';


abstract class TaskPriorityMedState extends Equatable {
  const TaskPriorityMedState();

  List<Object> get props => [];
}

class TaskPriorityMedStateLoading extends TaskPriorityMedState {}

class TaskPriorityMedStateFailLoad extends TaskPriorityMedState {}

class TaskPriorityMedStateSuccessLoad extends TaskPriorityMedState {
  final List<TaskModel> task;
  // handle for checklist user
  

  TaskPriorityMedStateSuccessLoad({this.task});

  List<Object> get props => [task];

  @override
  String toString() {
    return 'Data : { employee List: $task }';
  }
}
