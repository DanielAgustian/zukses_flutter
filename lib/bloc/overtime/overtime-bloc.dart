import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/overtime-services.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';

import 'overtime-event.dart';
import 'overtime-state.dart';

class OvertimeBloc extends Bloc<OvertimeEvent, OvertimeState> {
  StreamSubscription _subscription;

  final OvertimeServiceHTTP _overtimeServiceHTTP = OvertimeServiceHTTP();

  OvertimeBloc() : super(null);

  // Bloc for loadd all Overtime
  Stream<OvertimeState> mapAllOvertime(LoadAllOvertimeEvent event) async* {
    yield OvertimeStateLoading();
    // return list user model
    var res = await _overtimeServiceHTTP.fetchOvertime();
    if (res != null) {
      yield OvertimeStateSuccessLoad(overtime: res);
    } else {
      yield OvertimeStateFailLoad();
    }
  }

  Stream<OvertimeState> mapAddOvertime(AddOvertimeEvent event) async* {
    yield OvertimeStateLoading();
    // return list user model
    String date = "${event.date.year}-${event.date.month}-${event.date.day}";
    var res = await _overtimeServiceHTTP.postOvertime(
        date, event.startTime, event.endTime, event.project, event.reason);

    print("Delete Overtime Status " + res.toString());
    // directly throw into success load or fail add
    if (res == 200) {
      print("OvertimeStateSuccess");
      yield OvertimeStateSuccess();
    } else {
      print("OvertimeStateFail");
      yield OvertimeStateFail();
    }
  }

  Stream<OvertimeState> mapUpdatingOvertimeState(
      OvertimeEventDidUpdated event) async* {
    yield OvertimeStateSuccessLoad(overtime: event.overtime);
  }

  @override
  Stream<OvertimeState> mapEventToState(OvertimeEvent event) async* {
    if (event is LoadAllOvertimeEvent) {
      yield* mapAllOvertime(event);
    } else if (event is OvertimeEventDidUpdated) {
      yield* mapUpdatingOvertimeState(event);
    } else if (event is AddOvertimeEvent) {
      yield* mapAddOvertime(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
