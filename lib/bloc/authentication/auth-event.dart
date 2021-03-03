import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthEventWithGoogle extends AuthenticationEvent {
  const AuthEventWithGoogle();

  @override
  List<Object> get props => [];
}

class AuthEventUpdated extends AuthenticationEvent {
  final UserModel user;
  const AuthEventUpdated(this.user);

  @override
  List<Object> get props => [user];
}
