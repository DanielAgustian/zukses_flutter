import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/payment-services.dart';
import 'package:zukses_app_1/bloc/notification-tab/Meeting/notif-meeting-event.dart';
import 'package:zukses_app_1/bloc/notification-tab/Meeting/notif-meeting-state.dart';

class NotificationMeetingBloc
    extends Bloc<NotificationMeetingEvent, NotificationMeetingState> {
  NotificationMeetingBloc() : super(null);
  StreamSubscription _subscription;
  PaymentServicesHTTP _paymentServicesHTTP = PaymentServicesHTTP();
  @override
  Stream<NotificationMeetingState> mapEventToState(
      NotificationMeetingEvent event) async* {
    if (event is AddNotificationMeetingEvent) {
      yield* mapSentPayment(event);
    }
  }

  Stream<NotificationMeetingState> mapSentPayment(
      AddNotificationMeetingEvent event) async* {
    yield NotificationMeetingStateLoading();
    var res = _paymentServicesHTTP.sentPaymentData(event.payment);
    if (res != null) {
      print(res);
      yield NotificationMeetingStateSuccess();
    } else {
      yield NotificationMeetingStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
