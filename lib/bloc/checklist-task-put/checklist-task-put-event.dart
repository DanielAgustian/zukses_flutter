import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/checklist-model.dart';

abstract class CLTPEvent extends Equatable {
  const CLTPEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllCLTPEvent extends CLTPEvent {
  final String taskId;
  LoadAllCLTPEvent(this.taskId);
  List<Object> get props => [];
}

class AddCLTPEvent extends CLTPEvent {
  final String taskId;
  final String checkListName;
  AddCLTPEvent(this.taskId, this.checkListName);
  List<Object> get props => [];
}

class PutCLTPEvent extends CLTPEvent {
  final String checkListId;
  PutCLTPEvent(this.checkListId);
  List<Object> get props => [];
}

class CLTPEventDidUpdated extends CLTPEvent {
  final List<CheckListModel> model;
  const CLTPEventDidUpdated(this.model);

  @override
  List<Object> get props => [model];
}
