import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/auth-model.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class AuthEventLoginManual extends AuthenticationEvent {
  final String email, password;
  final String tokenFCM;
  const AuthEventLoginManual({this.email, this.password, this.tokenFCM});

  @override
  List<Object> get props => [email, password];
}

class AuthEventDetectGoogleSignIn extends AuthenticationEvent {
  final String email, name, image, tokenGoogle, tokenFCM;

  AuthEventDetectGoogleSignIn(
      {this.email, this.name, this.image, this.tokenGoogle, this.tokenFCM});
  @override
  List<Object> get props => [email, name, image, tokenGoogle];
}

class AuthEventLoginTeam extends AuthenticationEvent {
  final String email, password, link;
  const AuthEventLoginTeam({this.email, this.password, this.link});

  @override
  List<Object> get props => [email, password, link];
}

class AuthEventWithGoogle extends AuthenticationEvent {
  final String tokenFCM;
  const AuthEventWithGoogle({this.tokenFCM});

  @override
  List<Object> get props => [];
}

class AuthEventWithFacebook extends AuthenticationEvent {
  final String tokenFCM;
  const AuthEventWithFacebook({this.tokenFCM});

  @override
  List<Object> get props => [];
}

class AuthEventUpdated extends AuthenticationEvent {
  final AuthModel user;
  const AuthEventUpdated(this.user);

  @override
  List<Object> get props => [user];
}
