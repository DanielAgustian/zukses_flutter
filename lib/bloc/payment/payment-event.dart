import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/payment-model.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  List<Object> get props => [];
}
class AddPaymentEvent extends PaymentEvent {
  final PaymentModel payment;

  AddPaymentEvent(this.payment);
  List<Object> get props => [payment];
}