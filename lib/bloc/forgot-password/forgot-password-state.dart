import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  List<Object> get props => [];
}

class ForgotPasswordStateFailed extends ForgotPasswordState {}

class ForgotPasswordStateSuccess extends ForgotPasswordState {
  final int code;

  ForgotPasswordStateSuccess(this.code);
}

class ForgotPasswordStateLoading extends ForgotPasswordState {}
