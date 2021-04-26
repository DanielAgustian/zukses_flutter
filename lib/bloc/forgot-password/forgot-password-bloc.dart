import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/forgot-password-services.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-event.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  StreamSubscription _subscription;

  ForgotPasswordBloc() : super(null);

  ForgotPasswordServicesHTTP _forgotPasswordServicesHTTP =
      ForgotPasswordServicesHTTP();
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
  
    if (event is SentLinkEvent) {
      yield* mapSentLink(event);
    } else if (event is SentNewPasswordEvent) {
      yield* mapSentNewPassword(event);
    }
  }

  Stream<ForgotPasswordState> mapSentLink(SentLinkEvent event) async* {
    yield ForgotPasswordStateLoading();
    var res = await _forgotPasswordServicesHTTP.sentLinkToEmail(event.email, event.dynamicLink);
    if (res == 200) {
      yield ForgotPasswordStateSuccess(res);
    } else {
      yield ForgotPasswordStateFailed();
    }
  }

  Stream<ForgotPasswordState> mapSentNewPassword(
      SentNewPasswordEvent event) async* {
    yield ForgotPasswordStateLoading();
    var res = await _forgotPasswordServicesHTTP.sentNewPassword(event.password, event.token);
    if (res == 200) {
      yield ForgotPasswordStateSuccess(res);
    } else {
      yield ForgotPasswordStateFailed();
    }
  }
}
