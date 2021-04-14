import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/payment-model.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  List<Object> get props => [];
}

class SentLinkEvent extends ForgotPasswordEvent {
  final String email;
  final String dynamicLink;
  SentLinkEvent({this.email, this.dynamicLink});
  List<Object> get props => [];
}

class SentNewPasswordEvent extends ForgotPasswordEvent {
  final String password, token;
  SentNewPasswordEvent(this.password, this.token);
  List<Object> get props => [];
}
