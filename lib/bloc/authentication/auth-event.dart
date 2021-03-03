import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthEventLoginManual extends AuthenticationEvent {
  final String email, password;
  const AuthEventLoginManual({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthEventWithGoogle extends AuthenticationEvent {
  const AuthEventWithGoogle();

  @override
  List<Object> get props => [];
}

class AuthEventUpdated extends AuthenticationEvent {
  final AuthModel user;
  const AuthEventUpdated(this.user);

  @override
  List<Object> get props => [user];
}
