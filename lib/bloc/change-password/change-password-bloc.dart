import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/notification-navbar-services.dart';
import 'package:zukses_app_1/API/user-data-services.dart';

import 'change-password-event.dart';
import 'change-password-state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(null);
  StreamSubscription _subscription;
  UserDataServiceHTTP _userService = UserDataServiceHTTP();
  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is ChangePasswordPostEvent) {
      yield* mapChangePassword(event);
    }
  }

  Stream<ChangePasswordState> mapChangePassword(
      ChangePasswordPostEvent event) async* {
    yield ChangePasswordStateLoading();
    var res = await _userService.changePassword(
        event.password, event.newPassword, event.passwordConfirm);
    if (res != null) {
      if (res.toLowerCase() == "success") {
        yield ChangePasswordStateSuccess();
      } else {
        yield ChangePasswordStateFailedDiffPass();
      }
    } else {
      yield ChangePasswordStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
