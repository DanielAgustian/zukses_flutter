import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/facebook_auth-model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthStateLoading extends AuthenticationState {}

class AuthStateFailLoad extends AuthenticationState {}

class AuthStateSuccessLoad extends AuthenticationState {
  final AuthModel authUser;

  AuthStateSuccessLoad(this.authUser);

  List<Object> get props => [authUser];

  @override
  String toString() {
    return 'Data : { Authentication List: $authUser }';
  }
}

class AuthStateFacebookSuccessLoad extends AuthenticationState {
  final FBAuthModel fbauth;

  AuthStateFacebookSuccessLoad(this.fbauth);
  List<Object> get props => [fbauth];
  @override
  String toString() {
    return 'Data : { Authentication List: $fbauth }';
  }
}
class AuthStateFacebookFailLoad extends AuthenticationState {}
