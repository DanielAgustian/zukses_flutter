import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/payment-model.dart';

abstract class NotificationMeetingEvent extends Equatable {
  const NotificationMeetingEvent();

  List<Object> get props => [];
}

class AddNotificationMeetingEvent extends NotificationMeetingEvent {
  final PaymentModel payment;

  AddNotificationMeetingEvent(this.payment);
  List<Object> get props => [payment];
}
