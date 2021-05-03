import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/auth-model.dart';

import 'package:zukses_app_1/model/schedule-model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  List<Object> get props => [];
}

class RegisterStateFailed extends RegisterState {}

class RegisterStateSuccess extends RegisterState {
  final AuthModel authUser;

  RegisterStateSuccess(this.authUser);

  List<Object> get props => [authUser];

  @override
  String toString() {
    return 'Data : { Authentication List: $authUser }';
  }
}


class RegisterStateTeamMemberFailed extends RegisterState {}

class RegisterStateTeamMemberSuccess extends RegisterState {
  final AuthModel authUser;

  RegisterStateTeamMemberSuccess(this.authUser);

  List<Object> get props => [authUser];

  @override
  String toString() {
    return 'Data : { Authentication List: $authUser }';
  }
}
class RegisterStateCompanySuccess extends RegisterState {
  final int status;

  RegisterStateCompanySuccess(this.status);
  List<Object> get props => [status];
   @override
  String toString() {
    return 'Data : { Register Company Status: $status }';
  }
}
class RegisterStateCompanyFailed extends RegisterState {}

class RegisterStateTeamSuccess extends RegisterState {
  final int status;

  RegisterStateTeamSuccess(this.status);
  List<Object> get props => [status];
   @override
  String toString() {
    return 'Data : { Register Company Status: $status }';
  }
}

class RegisterStateTeamFailed extends RegisterState {}

class RegisterStateLoading extends RegisterState {}

class RegisterStateFailLoad extends RegisterState {}

class RegisterStateSuccessLoad extends RegisterState {
  final List<ScheduleModel> schedule;
  // handle for checklist user

  RegisterStateSuccessLoad({this.schedule});

  List<Object> get props => [schedule];

  @override
  String toString() {
    return 'Data : { employee List: $schedule }';
  }
}
