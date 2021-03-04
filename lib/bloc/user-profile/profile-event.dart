import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  List<Object> get props => [];
}

class EditProfileEvent extends ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  final String id;

  GetProfileEvent(this.id);

  List<Object> get props => [id];
}

class ProfileEventUpdated extends ProfileEvent {
  final UserModel user;
  const ProfileEventUpdated(this.user);

  @override
  List<Object> get props => [user];
}
