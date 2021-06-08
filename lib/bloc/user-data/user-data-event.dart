import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/user-model.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  List<Object> get props => [];
}

class UserDataGettingEvent extends UserDataEvent {
  @override
  List<Object> get props => [];
}

class UserChangeNotificationStatus extends UserDataEvent {
  final bool status;

  UserChangeNotificationStatus({this.status});

  @override
  List<Object> get props => [status];
}

class UserDataUpdateProfileEvent extends UserDataEvent {
  final File image;
  final String name, phone, link;

  UserDataUpdateProfileEvent(this.name, this.phone, {this.link, this.image});
  @override
  List<Object> get props => [];
}

class UserDataEventDidUpdated extends UserDataEvent {
  final UserModel user;
  const UserDataEventDidUpdated(this.user);

  @override
  List<Object> get props => [user];
}
