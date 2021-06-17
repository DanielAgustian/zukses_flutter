import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/payment-model.dart';

abstract class NotificationAttendanceEvent extends Equatable {
  const NotificationAttendanceEvent();

  List<Object> get props => [];
}

class AddNotificationAttendanceEvent extends NotificationAttendanceEvent {
  final PaymentModel payment;

  AddNotificationAttendanceEvent(this.payment);
  List<Object> get props => [payment];
}
