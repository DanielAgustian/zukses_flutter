import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/attendance-services.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';

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

  // BLOC clock out
  Stream<AttendanceState> mapClockOut() async* {
    yield AttendanceStateLoading();
    // return user model
    var res = await _attendanceService.createClockOut();

    // directly throw into success load or fail load
    if (res != null) {
      yield AttendanceStateSuccessClockOut(attendanceID: res);
    } else {
      yield AttendanceStateFailed();
    }
  }

  // BLOC for load all user attendance list
  Stream<AttendanceState> mapLoadUserAttendanceList(
      LoadUserAttendanceEvent event) async* {
    yield AttendanceStateLoading();
    // return user model
    var res = await _attendanceService.getUserAttendaceList(date: event.date);
    if (res != null) {
      yield AttendanceStateSuccessLoad(attendanceList: res);
    } else {
      yield AttendanceStateFailLoad();
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
    } else if (event is LoadUserAttendanceEvent) {
      yield* mapLoadUserAttendanceList(event);
    } else if (event is AttendanceEventDidUpdated) {
      yield* mapUpdatingAttendanceState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
