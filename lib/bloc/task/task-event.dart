import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/task-model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  List<Object> get props => [];
}

class GetAllTaskEvent extends TaskEvent {
  final int projectId;

  GetAllTaskEvent({this.projectId});
  List<Object> get props => [projectId];
}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;

  AddTaskEvent(this.task);
  List<Object> get props => [task];
}

class AddTaskFreeEvent extends TaskEvent {
  final TaskModel task;

  AddTaskFreeEvent(this.task);
  List<Object> get props => [task];
}


class UpdateTaskEvent extends TaskEvent{
  final TaskModel task;

  UpdateTaskEvent(this.task);

}