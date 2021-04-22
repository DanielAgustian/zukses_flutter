import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  List<Object> get props => [];
}

class GetAllTaskEvent extends TaskEvent {
  final List<TaskModel> task;

  GetAllTaskEvent({this.task});
  List<Object> get props => [task];
}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;

  AddTaskEvent(this.task);
  List<Object> get props => [task];
}

