import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/payment-model.dart';

abstract class NotificationTaskEvent extends Equatable {
  const NotificationTaskEvent();

  List<Object> get props => [];
}

class AddNotificationTaskEvent extends NotificationTaskEvent {
  final PaymentModel payment;

  AddNotificationTaskEvent(this.payment);
  List<Object> get props => [payment];
}
