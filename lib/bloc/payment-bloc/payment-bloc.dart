import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/payment-services.dart';
import 'package:zukses_app_1/bloc/payment-bloc/payment-event.dart';
import 'package:zukses_app_1/bloc/payment-bloc/payment-state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(null);
  StreamSubscription _subscription;
  PaymentServicesHTTP _paymentServicesHTTP = PaymentServicesHTTP();
  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is AddPaymentEvent) {
      yield* mapSentPayment(event);
    }
  }

  Stream<PaymentState> mapSentPayment(AddPaymentEvent event) async* {
    yield PaymentStateLoading();
    var res = _paymentServicesHTTP.sentPaymentData(event.payment);
    if (res != null) {
      print(res);
      yield PaymentStateSuccess();
    } else {
      yield PaymentStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
