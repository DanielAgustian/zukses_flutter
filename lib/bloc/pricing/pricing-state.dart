import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/pricing-model.dart';

abstract class PricingState extends Equatable {
  const PricingState();

  List<Object> get props => [];
}

class PricingStateFailed extends PricingState {}

class PricingStateSuccess extends PricingState {
  final List<PricingModel> pricing;

  PricingStateSuccess(this.pricing);
  List<Object> get props => [pricing];
}

class PricingStateLoading extends PricingState {}