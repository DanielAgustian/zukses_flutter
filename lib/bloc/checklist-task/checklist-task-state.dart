import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/checklist-model.dart';

abstract class CLTState extends Equatable {
  const CLTState();

  List<Object> get props => [];
}

class CLTStateLoading extends CLTState {}

class CLTStateGetFailLoad extends CLTState {}

class CLTStateGetSuccessLoad extends CLTState {
  final List<CheckListModel> listCheckList;
  // handle for checklist user
  final List<bool> boolCheckList;
  CLTStateGetSuccessLoad(this.boolCheckList, this.listCheckList);

  List<Object> get props => [listCheckList];

  @override
  String toString() {
    return 'Data : { employee List: $listCheckList }';
  }
}

class CLTStateAddFailLoad extends CLTState {}

class CLTStateAddSuccessLoad extends CLTState {
  final CheckListModel model;

  CLTStateAddSuccessLoad(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}

class CLTStatePutFailLoad extends CLTState {}

class CLTStatePutSuccessLoad extends CLTState {
  final CheckListModel model;

  CLTStatePutSuccessLoad(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}
