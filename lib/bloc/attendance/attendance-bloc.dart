import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/attendance-services.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/model/user-model.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  StreamSubscription _subscription;

  final AttendanceService _attendanceService = AttendanceService();

  AttendanceBloc() : super(null);

  // BLOC clock in
  Stream<AttendanceState> mapClockIn(AttendanceClockIn event) async* {
    yield AttendanceStateLoading();
    // return user model
    var res = await _attendanceService.createClockIn(event.image);

    // directly throw into success load or fail load
    if (res == 200 && res != null) {
      yield AttendanceStateSuccessClockIn();
    } else {
      yield AttendanceStateFailed();
    }
  }

  // BLOC clock in
  Stream<AttendanceState> mapClockOut() async* {
    yield AttendanceStateLoading();
    // return user model
    var res = await _attendanceService.createClockOut();

    // directly throw into success load or fail load
    if (res == 200 && res != null) {
      yield AttendanceStateSuccessClockOut();
    } else {
      yield AttendanceStateFailed();
    }
  }

  // BLOC for update the state when the user doing event
  Stream<AttendanceState> mapUpdatingAttendanceState(
      AttendanceEventDidUpdated event) async* {
    yield AttendanceStateSuccessLoad();
  }

  // Listener of all the event, and map to every function should be done
  @override
  Stream<AttendanceState> mapEventToState(AttendanceEvent event) async* {
    if (event is AttendanceClockIn) {
      yield* mapClockIn(event);
    } else if (event is AttendanceClockOut) {
      yield* mapClockOut();
    } else if (event is AuthEventUpdated) {
      yield* mapUpdatingAttendanceState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
