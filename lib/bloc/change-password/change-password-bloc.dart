import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/notification-navbar-services.dart';

import 'change-password-event.dart';
import 'change-password-state.dart';


class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(null);
  StreamSubscription _subscription;
  NotifNavServiceHTTP _ChangePasswordServicesHTTP = NotifNavServiceHTTP();
  @override
  Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async* {
    if (event is ChangePasswordPostEvent) {
      yield* mapChangePassword(event);
    }
  }

  Stream<ChangePasswordState> mapChangePassword(ChangePasswordPostEvent event) async* {
    yield ChangePasswordStateLoading();
    // var res = await _ChangePasswordServicesHTTP.fetchChangePassword();
    // if (res != null) {
    //   if (res.length > 0) {
    //     yield ChangePasswordStateSuccessLoad(res);
    //   } else {
    //     yield ChangePasswordStateFailed();
    //   }
    // } else {
    //   yield CshangePasswordStateFailed();
    // }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
