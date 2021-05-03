import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/checklist-model.dart';


abstract class CLTPState extends Equatable {
  const CLTPState();

  List<Object> get props => [];
}

class CLTPStateLoading extends CLTPState {}

class CLTPStateGetFailLoad extends CLTPState {}

class CLTPStateGetSuccessLoad extends CLTPState {
  final List<CheckListModel> listCheckList;
  // handle for checklist user
  final List<bool> boolCheckList;
  CLTPStateGetSuccessLoad(this.boolCheckList, this.listCheckList);

  List<Object> get props => [listCheckList];

  @override
  String toString() {
    return 'Data : { employee List: $listCheckList }';
  }
}

class CLTPStateAddFailLoad extends CLTPState {}

class CLTPStateAddSuccessLoad extends CLTPState {
  final CheckListModel model;

  CLTPStateAddSuccessLoad(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}

class CLTPStatePutFailLoad extends CLTPState {}

class CLTPStatePutSuccessLoad extends CLTPState {
  final CheckListModel model;

  CLTPStatePutSuccessLoad(this.model);
  List<Object> get props => [model];

  @override
  String toString() {
    return 'Data : { employee List: $model }';
  }
}
