import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/company-services.dart';
import 'package:zukses_app_1/bloc/company-profile/company-event.dart';
import 'package:zukses_app_1/bloc/company-profile/company-state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  StreamSubscription _subscription;

  final CompanyServiceHTTP _companyServiceHTTP = CompanyServiceHTTP();

  CompanyBloc() : super(null);

  // Bloc for loadd all Company
  Stream<CompanyState> mapAllCompany() async* {
    yield CompanyStateLoading();
    // return list user model
    var res = await _companyServiceHTTP.fetchCompanyProfile();

    // return checkbox handler

    // directly throw into success load or fail load
    if (res != null) {
      yield CompanyStateSuccessLoad(company: res);
    } else {
      yield CompanyStateFailLoad();
    }
  }

  Stream<CompanyState> mapAllCompanyCode() async* {
    yield CompanyStateLoading();
    // return list user model
    var res = await _companyServiceHTTP.fetchCompanyCode(); //= await _companyServiceHTTP.fetchCompanyProfile();

    // return checkbox handler

    // directly throw into success load or fail load
    if (res != null) {
      yield CompanyCodeStateSuccessLoad(company: res);
    } else {
      yield CompanyCodeStateFailLoad();
    }
  }

  Stream<CompanyState> mapUpdatingCompanyState(
      CompanyEventDidUpdated event) async* {
    yield CompanyStateSuccessLoad(company: event.company);
  }

  @override
  Stream<CompanyState> mapEventToState(CompanyEvent event) async* {
    if (event is CompanyEventGetProfile) {
      yield* mapAllCompany();
    } else if (event is CompanyEventDidUpdated) {
      yield* mapUpdatingCompanyState(event);
    } else if (event is CompanyEventGetCode) {
      yield* mapAllCompanyCode();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
