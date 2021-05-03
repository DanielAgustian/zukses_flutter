import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/task-model.dart';

abstract class ChangeTaskEvent extends Equatable {
  const ChangeTaskEvent();

  List<Object> get props => [];
}

// Load all employee data
class ChangeTaskUpdateEvent extends ChangeTaskEvent {
  final String idTask;
  final String progress;
  
  ChangeTaskUpdateEvent(this.idTask, this.progress);
  List<Object> get props => [];
}

class ChangeTaskUpdateByDropdownEvent extends ChangeTaskEvent {
  final String idTask;
  final String progress;
  
  ChangeTaskUpdateByDropdownEvent(this.idTask, this.progress);
  List<Object> get props => [];
}
