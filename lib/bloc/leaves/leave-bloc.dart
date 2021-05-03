import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/leave-services.dart';

import 'leave-event.dart';
import 'leave-state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  StreamSubscription _subscription;

  final LeaveServiceHTTP _leaveServiceHTTP = LeaveServiceHTTP();

  LeaveBloc() : super(null);

  // Bloc for loadd all Leave
  Stream<LeaveState> mapAllLeave() async* {
    yield LeaveStateLoading();
    // return list user model
    var res = await _leaveServiceHTTP.fetchLeave();
    if (res != null) {
      yield LeaveStateSuccessLoad(leave: res);
    } else {
      yield LeaveStateFailLoad();
    }
  }

  Stream<LeaveState> mapCreateLeave(AddLeaveEvent event) async* {
    yield LeaveStateLoading();
    // return list user model
    var res = await _leaveServiceHTTP.createLeave(
        event.leaveId,
        event.leaveModel.duration,
        event.leaveModel.leaveDate,
        event.leaveModel.reason,
        event.leaveModel.startTime,
        event.leaveModel.endTime);
    print("MapCreateLeave Here");
    print("Delete leave Status" + res.toString());
    // directly throw into success load or fail add
    if (res == 200) {
      yield LeaveStateSuccess();
    } else {
      yield LeaveStateFail();
    }
  }

  Stream<LeaveState> mapUpdatingLeaveState(LeaveEventDidUpdated event) async* {
    yield LeaveStateSuccessLoad(leave: event.leave);
  }

  @override
  Stream<LeaveState> mapEventToState(LeaveEvent event) async* {
    if (event is LoadAllLeaveEvent) {
      yield* mapAllLeave();
    } else if (event is LeaveEventDidUpdated) {
      yield* mapUpdatingLeaveState(event);
    } else if (event is AddLeaveEvent) {
      yield* mapCreateLeave(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
