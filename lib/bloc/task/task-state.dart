import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  List<Object> get props => [];
}

class TaskStateLoading extends TaskState {}

class TaskStateAddSuccessLoad extends TaskState {
  final int project;

  TaskStateAddSuccessLoad({this.project});

  List<Object> get props => [project];

  @override
  String toString() {
    return 'Data : { employee List: $project }';
  }
}

class TaskStateAddFailLoad extends TaskState {}

class TaskStateFailLoad extends TaskState {}

class TaskStateSuccessLoad extends TaskState {
  final List<TaskModel> task;

  TaskStateSuccessLoad({this.task});

  List<Object> get props => [task];

  @override
  String toString() {
    return 'Data : { employee List: $task }';
  }
}

class TaskStateLowPriorityFailLoad extends TaskState {}

class TaskStateLowPrioritySuccessLoad extends TaskState {
  final List<TaskModel> task;

  TaskStateLowPrioritySuccessLoad({this.task});

  List<Object> get props => [task];

  @override
  String toString() {
    return 'Data : { employee List: $task }';
  }
}
class TaskStateUpdateSuccess extends TaskState {
  final int kode;

  TaskStateUpdateSuccess({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode }';
  }
}

class TaskStateUpdateFail extends TaskState {}