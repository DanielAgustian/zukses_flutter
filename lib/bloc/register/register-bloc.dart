import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/register-services.dart';
import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(null);
  RegisterServicesHTTP _registerServicesHTTP = RegisterServicesHTTP();
  StreamSubscription _subscription;
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    // TODO: implement mapEventToState
    if (event is AddRegisterIndividuEvent) {
      yield* mapAddRegisIndividual(event);
    } else if (event is AddRegisterTeamEvent) {
      yield* mapAddRegisTeam(event);
    } else if (event is AddRegisterCompanyEvent) {
      yield* mapAddRegisCompany(event);
    }
  }

  Stream<RegisterState> mapAddRegisIndividual(
      AddRegisterIndividuEvent event) async* {
    yield RegisterStateLoading();
    var res =
        await _registerServicesHTTP.createRegisterIndividual(event.register);
    if (res != null) {
      yield RegisterStateSuccess(res);
    } else {
      yield RegisterStateFailed();
    }
  }

  Stream<RegisterState> mapAddRegisTeam(AddRegisterTeamEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterTeam(
        event.register, event.namaTeam);
    if (res != null) {
      yield RegisterStateSuccess(res);
    } else {
      yield RegisterStateFailed();
    }
  }

  Stream<RegisterState> mapAddRegisCompany(
      AddRegisterCompanyEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterCompany(
        event.register, event.kode);
    if (res != null) {
      yield RegisterStateSuccess(res);
    } else {
      yield RegisterStateFailed();
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
