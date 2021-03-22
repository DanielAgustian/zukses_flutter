import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/leave-type-services.dart';

import 'leave-type-event.dart';
import 'leave-type-state.dart';

class LeaveTypeBloc extends Bloc<LeaveTypeEvent, LeaveTypeState> {
  StreamSubscription _subscription;

  final LeaveTypeServiceHTTP _leaveTypeServiceHTTP = LeaveTypeServiceHTTP();

  LeaveTypeBloc() : super(null);

  // Bloc for loadd all LeaveType
  Stream<LeaveTypeState> mapAllLeaveType() async* {
    yield LeaveTypeStateLoading();
    // return list user model
    var res = await _leaveTypeServiceHTTP.fetchLeaveType();

    // return checkbox handler
    List<bool> bools = [];
    
    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      for (var i = 0; i < res.length; i++) {
        bools.add(false);
      }
      yield LeaveTypeStateSuccessLoad(leaveType: res);
    } else {
      yield LeaveTypeStateFailLoad();
    }
  }

  Stream<LeaveTypeState> mapUpdatingLeaveTypeState(
      LeaveTypeEventDidUpdated event) async* {
    yield LeaveTypeStateSuccessLoad(leaveType: event.leaveType);
  }

  @override
  Stream<LeaveTypeState> mapEventToState(LeaveTypeEvent event) async* {
    if (event is LoadAllLeaveTypeEvent) {
      yield* mapAllLeaveType();
    } else if (event is LeaveTypeEventDidUpdated) {
      yield* mapUpdatingLeaveTypeState(event);
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
