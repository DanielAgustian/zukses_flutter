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
    
    if (event is AddRegisterIndividuEvent) {
      yield* mapAddRegisIndividual(event);
    } else if (event is AddRegisterTeamEvent) {
      yield* mapAddRegisTeam(event);
    } else if (event is AddRegisterCompanyEvent) {
      yield* mapAddRegisCompany(event);
    } else if (event is AddRegisterTeamMemberEvent) {
      yield* mapAddRegisTeamMember(event);
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

  Stream<RegisterState> mapAddRegisTeamMember(
      AddRegisterTeamMemberEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterTeamMember(
        event.register, event.link);
    if (res != null) {
      yield RegisterStateTeamMemberSuccess(res);
    } else {
      yield RegisterStateTeamMemberFailed();
    }
  }

  Stream<RegisterState> mapAddRegisTeam(AddRegisterTeamEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterTeam(
        event.token, event.namaTeam, event.link, event.email);
    if (res != null) {
      yield RegisterStateTeamSuccess(res);
    } else {
      yield RegisterStateTeamFailed();
    }
  }

  Stream<RegisterState> mapAddRegisCompany(
      AddRegisterCompanyEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterToCompany(
        event.token, event.kode);

    print("AddRegisCompanyEvent" + res.toString());
    if (res == 200) {
      yield RegisterStateCompanySuccess(res);
    } else {
      yield RegisterStateCompanyFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}