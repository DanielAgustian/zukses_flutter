import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  List<Object> get props => [];
}

class ChangePasswordPostEvent extends ChangePasswordEvent {
  final String password, newPassword;
  ChangePasswordPostEvent({this.password, this.newPassword});
  List<Object> get props => [];
}
