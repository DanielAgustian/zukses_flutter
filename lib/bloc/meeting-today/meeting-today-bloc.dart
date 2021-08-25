import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/meeting-services.dart';

import 'meeting-today-event.dart';
import 'meeting-today-state.dart';

class MeetingTodayBloc extends Bloc<MeetingTodayEvent, MeetingTodayState> {
  StreamSubscription _subscription;

  final MeetingServicesHTTP _scheduleServicesHTTP = MeetingServicesHTTP();

  MeetingTodayBloc() : super(null);

  // Bloc for loadd all MeetingToday
  Stream<MeetingTodayState> mapAllMeetingToday() async* {
    yield MeetingTodayStateLoading();
    // return list user model
    var res = await _scheduleServicesHTTP.fetchAcceptedScheduleToday();

    // return checkbox handler

    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      yield MeetingTodayStateSuccessLoad(schedule: res);
    } else {
      yield MeetingTodayStateFailLoad();
    }
  }

  Stream<MeetingTodayState> mapUpdatingMeetingTodayState(
      MeetingTodayEventDidUpdated event) async* {
    yield MeetingTodayStateSuccessLoad(schedule: event.schedule);
  }

  @override
  Stream<MeetingTodayState> mapEventToState(MeetingTodayEvent event) async* {
    if (event is LoadAllMeetingTodayEvent) {
      yield* mapAllMeetingToday();
    } else if (event is MeetingTodayEventDidUpdated) {
      yield* mapUpdatingMeetingTodayState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
