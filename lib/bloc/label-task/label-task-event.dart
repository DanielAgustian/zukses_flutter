import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/label-task-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

abstract class LabelTaskEvent extends Equatable {
  const LabelTaskEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllLabelTaskEvent extends LabelTaskEvent {
  LoadAllLabelTaskEvent();
  List<Object> get props => [];
}

class AddLabelTaskEvent extends LabelTaskEvent {
  final String name;
  AddLabelTaskEvent(this.name);
  List<Object> get props => [];
}

class LabelTaskEventDidUpdated extends LabelTaskEvent {
  final List<LabelTaskModel> labelTask;
  const LabelTaskEventDidUpdated(this.labelTask);

  @override
  List<Object> get props => [labelTask];
}
