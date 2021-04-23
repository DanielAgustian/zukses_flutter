import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  List<Object> get props => [];
}

class PaymentStateFailed extends PaymentState {}

class PaymentStateSuccess extends PaymentState {}

class PaymentStateLoading extends PaymentState {}
