import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllEmployeeEvent extends EmployeeEvent {
  LoadAllEmployeeEvent();
  List<Object> get props => [];
}

class EmployeeEventDidUpdated extends EmployeeEvent {
  final List<UserModel> employee;
  const EmployeeEventDidUpdated(this.employee);

  @override
  List<Object> get props => [employee];
}
