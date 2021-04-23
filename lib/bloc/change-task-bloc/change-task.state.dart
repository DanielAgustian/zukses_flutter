import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

abstract class ChangeTaskState extends Equatable {
  const ChangeTaskState();

  List<Object> get props => [];
}

class ChangeTaskStateLoading extends ChangeTaskState {}

class ChangeTaskStateFailLoad extends ChangeTaskState {}

class ChangeTaskStateSuccessLoad extends ChangeTaskState {
  final int code;
  // handle for checklist user

  ChangeTaskStateSuccessLoad({this.code});

  List<Object> get props => [code];

  @override
  String toString() {
    return 'Data : { employee List: $code}';
  }
}
class ChangeTaskStateDropdownFailLoad extends ChangeTaskState {}

class ChangeTaskStateDropdownSuccessLoad extends ChangeTaskState {
  final int code;
  // handle for checklist user

  ChangeTaskStateDropdownSuccessLoad({this.code});

  List<Object> get props => [code];

  @override
  String toString() {
    return 'Data : { employee List: $code}';
  }
}