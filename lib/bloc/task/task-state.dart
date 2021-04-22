import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/project-model.dart';
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
  final List<TaskModel> project;

  TaskStateSuccessLoad({this.project});

  List<Object> get props => [project];

  @override
  String toString() {
    return 'Data : { employee List: $project }';
  }
}
