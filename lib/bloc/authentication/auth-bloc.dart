import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';
import 'package:zukses_app_1/model/auth-model.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  StreamSubscription _subscription;
  final AuthenticationRepository _authenticationRepository;

  final AuthServiceHTTP _authenticationService = AuthServiceHTTP();

  AuthenticationBloc({@required AuthenticationRepository authRepo})
      : assert(authRepo != null),
        _authenticationRepository = authRepo,
        super(AuthStateLoading());

  // BLOC for login with google
  Stream<AuthenticationState> mapLoginGoogle() async* {
    // return user model
    // var res = await _authenticationRepository.signInWithGoogle();

    // // directly throw into success load or fail load
    // if (res is AuthModel && res != null) {
    //   yield AuthStateSuccessLoad(res);
    // } else {
    //   yield AuthStateFailLoad();
    // }
  }

  // BLOC for login manually using email and password
  Stream<AuthenticationState> mapLoginManual(
      AuthEventLoginManual event) async* {
    // return auth model
    var res =
        await _authenticationService.createLogin(event.email, event.password);

    // directly throw into success load or fail load
    if (res is AuthModel && res != null) {
      yield AuthStateSuccessLoad(res);
    } else {
      yield AuthStateFailLoad();
    }
  }

  // BLOC for update the state when the user doing event
  Stream<AuthenticationState> mapUpdatingAuthState(
      AuthEventUpdated event) async* {
    yield AuthStateSuccessLoad(event.user);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthEventWithGoogle) {
      yield* mapLoginGoogle();
    } else if (event is AuthEventLoginManual) {
      yield* mapLoginManual(event);
    } else if (event is AuthEventUpdated) {
      yield* mapUpdatingAuthState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
