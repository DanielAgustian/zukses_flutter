import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/label-task-model.dart';



abstract class LabelTaskState extends Equatable {
  const LabelTaskState();

  List<Object> get props => [];
}

class LabelTaskStateLoading extends LabelTaskState {}

class LabelTaskStateFailLoad extends LabelTaskState {}

class LabelTaskStateSuccessLoad extends LabelTaskState {
  final List<LabelTaskModel> labelTask;
  // handle for checklist user
  

  LabelTaskStateSuccessLoad({this.labelTask});

  List<Object> get props => [labelTask];

  @override
  String toString() {
    return 'Data : { employee List: $labelTask }';
  }
}

class LabelTaskAddStateFailLoad extends LabelTaskState {}

class LabelTaskAddStateSuccessLoad extends LabelTaskState {
  final int kode;
  // handle for checklist user
  

  LabelTaskAddStateSuccessLoad({this.kode});

  List<Object> get props => [kode];

  @override
  String toString() {
    return 'Data : { employee List: $kode}';
  }
}