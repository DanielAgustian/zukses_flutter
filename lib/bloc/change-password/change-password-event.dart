import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  List<Object> get props => [];
}

class ChangePasswordPostEvent extends ChangePasswordEvent {
  final String password, newPassword, passwordConfirm;
  ChangePasswordPostEvent(
      {this.password, this.newPassword, this.passwordConfirm});
  List<Object> get props => [];
}
