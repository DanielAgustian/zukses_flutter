import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  List<Object> get props => [];
}

class AuthStateLoading extends AuthenticationState {}

class AuthStateFailLoad extends AuthenticationState {}

class AuthStateSuccessLoad extends AuthenticationState {
  final UserModel authUser;

  AuthStateSuccessLoad(this.authUser);

  List<Object> get props => [authUser];

  @override
  String toString() {
    return 'Data : { Authentication List: $authUser }';
  }
}
