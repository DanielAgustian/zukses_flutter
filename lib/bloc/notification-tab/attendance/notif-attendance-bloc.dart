import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/payment-services.dart';
import 'package:zukses_app_1/bloc/notification-tab/attendance/notif-attendance-event.dart';
import 'package:zukses_app_1/bloc/notification-tab/attendance/notif-attendance-state.dart';

class NotificationAttendanceBloc
    extends Bloc<NotificationAttendanceEvent, NotificationAttendanceState> {
  NotificationAttendanceBloc() : super(null);
  StreamSubscription _subscription;
  PaymentServicesHTTP _paymentServicesHTTP = PaymentServicesHTTP();
  @override
  Stream<NotificationAttendanceState> mapEventToState(
      NotificationAttendanceEvent event) async* {
    if (event is AddNotificationAttendanceEvent) {
      yield* mapSentPayment(event);
    }
  }

  Stream<NotificationAttendanceState> mapSentPayment(
      AddNotificationAttendanceEvent event) async* {
    yield NotificationAttendanceStateLoading();
    var res = _paymentServicesHTTP.sentPaymentData(event.payment);
    if (res != null) {
      print(res);
      yield NotificationAttendanceStateSuccess();
    } else {
      yield NotificationAttendanceStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
