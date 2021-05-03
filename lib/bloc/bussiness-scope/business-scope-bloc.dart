import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/business-scope-service.dart';

import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-event.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-state.dart';


class BussinessScopeBloc extends Bloc<BussinessScopeEvent, BussinessScopeState> {
  StreamSubscription _subscription;

  final BusinessScopeServiceHTTP _businessScopeServiceHTTP = BusinessScopeServiceHTTP();

  BussinessScopeBloc() : super(null);

  // Bloc for loadd all BussinessScope
  Stream<BussinessScopeState> mapAllBussinessScope() async* {
    yield BussinessScopeStateLoading();
    // return list user model
    var res = await _businessScopeServiceHTTP.fetchBusinessScope();

    // return checkbox handler
   
    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
     
      yield BussinessScopeStateSuccessLoad(bussinessScope: res);
    } else {
      yield BussinessScopeStateFailLoad();
    }
  }

  Stream<BussinessScopeState> mapUpdatingBussinessScopeState(
      BussinessScopeEventDidUpdated event) async* {
    yield BussinessScopeStateSuccessLoad(bussinessScope: event.bussinessScope);
  }

  @override
  Stream<BussinessScopeState> mapEventToState(BussinessScopeEvent event) async* {
    if (event is LoadAllBussinessScopeEvent) {
      yield* mapAllBussinessScope();
    } else if (event is BussinessScopeEventDidUpdated) {
      yield* mapUpdatingBussinessScopeState(event);
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
