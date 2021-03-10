import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  List<Object> get props => [];
}

class EmployeeStateLoading extends EmployeeState {}

class EmployeeStateFailLoad extends EmployeeState {}

class EmployeeStateSuccessLoad extends EmployeeState {
  final List<UserModel> employees;
  // handle for checklist user
  final List<bool> checklist;

  EmployeeStateSuccessLoad({this.employees, this.checklist});

  List<Object> get props => [employees, checklist];

  @override
  String toString() {
    return 'Data : { employee List: $employees }';
  }
}
