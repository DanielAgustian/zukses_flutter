import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  List<Object> get props => [];
}

// Handle login on fetch user data
class ProfileStateLoading extends ProfileState {}

// Handle when success to change in user data
class ProfileStateSuccess extends ProfileState {}

// Handle when failed to change in user data
class ProfileStateFailed extends ProfileState {}

// Handle when failed to load user data
class ProfileStateFailLoad extends ProfileState {}

// Handle when success to load user data
class ProfileStateSuccessLoad extends ProfileState {
  final UserModel _userModel;

  ProfileStateSuccessLoad(this._userModel);

  List<Object> get props => [_userModel];

  @override
  String toString() {
    return 'Data : { Profilen List: $_userModel }';
  }
}
