import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/payment-services.dart';
import 'package:zukses_app_1/bloc/notification-tab/Task/notif-Task-event.dart';
import 'package:zukses_app_1/bloc/notification-tab/Task/notif-Task-state.dart';

class NotificationTaskBloc
    extends Bloc<NotificationTaskEvent, NotificationTaskState> {
  NotificationTaskBloc() : super(null);
  StreamSubscription _subscription;
  PaymentServicesHTTP _paymentServicesHTTP = PaymentServicesHTTP();
  @override
  Stream<NotificationTaskState> mapEventToState(
      NotificationTaskEvent event) async* {
    if (event is AddNotificationTaskEvent) {
      yield* mapSentPayment(event);
    }
  }

  Stream<NotificationTaskState> mapSentPayment(
      AddNotificationTaskEvent event) async* {
    yield NotificationTaskStateLoading();
    var res = _paymentServicesHTTP.sentPaymentData(event.payment);
    if (res != null) {
      print(res);
      yield NotificationTaskStateSuccess();
    } else {
      yield NotificationTaskStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
