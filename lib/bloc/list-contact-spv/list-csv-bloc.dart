import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/contact-supervisor-service.dart';

import 'list-csv-event.dart';

import 'list-csv-state.dart';

class ListCSVBloc extends Bloc<ListCSVEvent, ListCSVState> {
  ListCSVBloc() : super(null);
  StreamSubscription _subscription;
  ContactSupervisorServiceHTTP _cspv =
      ContactSupervisorServiceHTTP(); //CompanyServiceHTTP _companyServicesHTTP = CompanyServiceHTTP();
  @override
  Stream<ListCSVState> mapEventToState(ListCSVEvent event) async* {
    if (event is ListCSVGetListEvent) {
      yield* mapGetListCSVList(event);
    }
  }

  Stream<ListCSVState> mapGetListCSVList(ListCSVGetListEvent event) async* {
    yield ListCSVStateLoading();
    var res = await _cspv.getContactSupervisorList();

    if (res != null) {
      yield ListCSVGetListStateSuccess(res);
    } else {
      yield ListCSVGetListStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
