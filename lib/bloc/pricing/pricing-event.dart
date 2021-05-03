import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/pricing-model.dart';

abstract class PricingEvent extends Equatable {
  const PricingEvent();

  List<Object> get props => [];
}

class GetPricingEvent extends PricingEvent {
  final List<PricingModel> pricing;

  GetPricingEvent({this.pricing});
  List<Object> get props => [pricing];
}
