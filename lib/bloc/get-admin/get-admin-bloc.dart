import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/company-services.dart';
import 'package:zukses_app_1/API/notification-navbar-services.dart';

import 'get-admin-event.dart';

import 'get-admin-state.dart';

class GetAdminBloc extends Bloc<GetAdminEvent, GetAdminState> {
  GetAdminBloc() : super(null);
  StreamSubscription _subscription;
  CompanyServiceHTTP _companyServicesHTTP = CompanyServiceHTTP();
  @override
  Stream<GetAdminState> mapEventToState(GetAdminEvent event) async* {
    if (event is GetAdminAllEvent) {
      yield* mapGetAdmin(event);
    }
  }

  Stream<GetAdminState> mapGetAdmin(GetAdminAllEvent event) async* {
    yield GetAdminStateLoading();
    var res = await _companyServicesHTTP.fetchAdmin();

    if (res != null) {
      
      yield GetAdminStateSuccess(res);
      
    } else {
      yield GetAdminStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
