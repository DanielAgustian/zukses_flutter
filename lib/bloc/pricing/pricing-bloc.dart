import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/pricing-services.dart';
import 'package:zukses_app_1/bloc/pricing/pricing-event.dart';
import 'package:zukses_app_1/bloc/pricing/pricing-state.dart';

class PricingBloc extends Bloc<PricingEvent, PricingState> {
  PricingBloc() : super(null);
  StreamSubscription _subscription;
  PricingServicesHTTP _paymentServicesHTTP = PricingServicesHTTP();
  @override
  Stream<PricingState> mapEventToState(PricingEvent event) async* {
    if (event is GetPricingEvent) {
      yield* mapGetPricing(event);
    }
  }

  Stream<PricingState> mapGetPricing(GetPricingEvent event) async* {
    yield PricingStateLoading();
    var res = await _paymentServicesHTTP.fetchPricing();
    if (res != null) {
      print(res);
      yield PricingStateSuccess(res);
    } else {
      yield PricingStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
