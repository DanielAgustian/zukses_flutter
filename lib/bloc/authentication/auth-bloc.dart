import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  StreamSubscription _subscription;
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc({@required AuthenticationRepository authRepo})
      : assert(authRepo != null),
        _authenticationRepository = authRepo,
        super(AuthStateLoading());

  // BLOC for login with google
  Stream<AuthenticationState> mapLoginGoogle() async* {
    // return user model
    var res = await _authenticationRepository.signInWithGoogle();

    // directly throw into success load or fail load
    if (res is UserModel && res != null) {
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
