import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/auth-model.dart'; 

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
class AuthEventLoginTeam extends AuthenticationEvent{
  final String email, password, link;
  const AuthEventLoginTeam({this.email, this.password, this.link});

  @override
  List<Object> get props => [email, password,link];
}
class AuthEventWithGoogle extends AuthenticationEvent {
  const AuthEventWithGoogle();

  @override
  List<Object> get props => [];
}

class AuthEventWithFacebook extends AuthenticationEvent {
  const AuthEventWithFacebook();

  @override
  List<Object> get props => [];
}
class AuthEventUpdated extends AuthenticationEvent {
  final AuthModel user;
  const AuthEventUpdated(this.user);

  @override
  List<Object> get props => [user];
}
