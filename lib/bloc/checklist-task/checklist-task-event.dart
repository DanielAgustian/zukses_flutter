import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/checklist-model.dart';

abstract class CLTEvent extends Equatable {
  const CLTEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllCLTEvent extends CLTEvent {
  final String taskId;
  LoadAllCLTEvent(this.taskId);
  List<Object> get props => [];
}

class AddCLTEvent extends CLTEvent {
  final String taskId;
  final String checkListName;
  AddCLTEvent(this.taskId, this.checkListName);
  List<Object> get props => [];
}

class PutCLTEvent extends CLTEvent {
  final String checkListId;
  PutCLTEvent(this.checkListId);
  List<Object> get props => [];
}

class CLTEventDidUpdated extends CLTEvent {
  final List<CheckListModel> model;
  const CLTEventDidUpdated(this.model);

  @override
  List<Object> get props => [model];
}
