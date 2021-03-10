import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  List<Object> get props => [];
}

class UserDataStateLoading extends UserDataState {}

class UserDataFailLoad extends UserDataState {}

class UserDataStateSuccessLoad extends UserDataState {
  final UserModel userModel;

  UserDataStateSuccessLoad(this.userModel);

  List<Object> get props => [userModel];

  @override
  String toString() {
    return 'Data : { Authentication List: $userModel }';
  }
}
