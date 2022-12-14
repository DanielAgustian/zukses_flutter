import 'package:zukses_app_1/API/meeting-services.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';

class MeetingBloc extends Bloc<MeetingEvent, MeetingState> {
  StreamSubscription _subscription;

  final MeetingServicesHTTP _meetingServicesHTTP = MeetingServicesHTTP();

  MeetingBloc() : super(null);

  // Bloc for add meeting
  Stream<MeetingState> mapAddMeeting(AddMeetingEvent event) async* {
    yield MeetingStateLoading();
    // return list user model
    var res = await _meetingServicesHTTP.createSchedule(
        event.model.title,
        event.model.description,
        event.model.date,
        event.model.repeat,
        event.model.userID,
        event.model.meetingEndTime);

    // directly throw into success load or fail add
    if (res == 200) {
      yield MeetingStateSuccess();
    } else {
      yield MeetingStateFail();
    }
  }

  Stream<MeetingState> mapUpdateMeeting(UpdateMeetingEvent event) async* {
    yield MeetingStateLoading();
    // return list user model
    var res = await _meetingServicesHTTP.updateSchedule(
        event.model.title,
        event.model.description,
        event.model.date,
        event.model.repeat,
        event.model.userID,
        event.meetingID,
        event.model.meetingEndTime);

    // directly throw into success load or fail add
    if (res == 200) {
      yield MeetingStateUpdateSuccess();
    } else {
      yield MeetingStateUpdateFailed();
    }
  }

  Stream<MeetingState> mapDeleteMeeting(DeleteMeetingEvent event) async* {
    yield MeetingStateLoading();
    // return list user model
    var res = await _meetingServicesHTTP.postDeleteSchedule(event.meetingID);
    // directly throw into success load or fail add
    if (res == 200) {
      yield MeetingStateSuccess();
    } else {
      yield MeetingStateFail();
    }
  }

  Stream<MeetingState> mapLoadAllMeeting(LoadAllMeetingEvent event) async* {
    yield MeetingStateLoading();
    var res = await _meetingServicesHTTP.fetchScheduleData();

    if (res != null && res.length > 0) {
      yield MeetingStateSuccessLoad(meetings: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  Stream<MeetingState> mapLoadDetailMeeting(
      LoadDetailMeetingEvent event) async* {
    yield MeetingStateLoading();
    var res = await _meetingServicesHTTP.fetchScheduleDetail(event.meetingID);

    if (res != null) {
      yield MeetingStateDetailSuccessLoad(meeting: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  Stream<MeetingState> mapUpdatingMeetingState(
      MeetingEventDidUpdated event) async* {
    yield MeetingStateSuccessLoad(meetings: event.meeting);
  }

  Stream<MeetingState> mapLoadUnresponseMeeting(
      GetUnresponseMeetingEvent event) async* {
    yield MeetingStateLoading();
    var res = await _meetingServicesHTTP.fetchUnresponseScheduleData();

    if (res != null) {
      yield MeetingStateSuccessLoad(meetings: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  Stream<MeetingState> mapLoadRejectedMeeting(
      GetRejectedMeetingEvent event) async* {
    yield MeetingStateLoading();
    var res = await _meetingServicesHTTP.fetchRejectedScheduleData();

    if (res != null) {
      yield MeetingStateSuccessLoad(meetings: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  Stream<MeetingState> mapPostAcceptanceMeeting(
      PostAcceptanceMeetingEvent event) async* {
    yield MeetingStateLoading();
    // return list user model
    var res = await _meetingServicesHTTP.postAcceptance(
        event.meetingId, event.accept, event.reason);

    // directly throw into success load or fail add
    if (res == 200) {
      yield MeetingStateSuccess();
    } else {
      yield MeetingStateFail();
    }
  }

  Stream<MeetingState> mapLoadAcceptedMeeting(
      GetAcceptedMeetingEvent event) async* {
    yield MeetingStateLoading();
    var res = await _meetingServicesHTTP.fetchAcceptedScheduleData(
        month: event.month, year: event.year);

    if (res != null) {
      yield MeetingStateSuccessLoad(meetings: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  @override
  Stream<MeetingState> mapEventToState(MeetingEvent event) async* {
    if (event is AddMeetingEvent) {
      yield* mapAddMeeting(event);
    } else if (event is MeetingEventDidUpdated) {
      yield* mapUpdatingMeetingState(event);
    } else if (event is LoadAllMeetingEvent) {
      yield* mapLoadAllMeeting(event);
    } else if (event is LoadDetailMeetingEvent) {
      yield* mapLoadDetailMeeting(event);
    } else if (event is DeleteMeetingEvent) {
      yield* mapDeleteMeeting(event);
    } else if (event is GetUnresponseMeetingEvent) {
      yield* mapLoadUnresponseMeeting(event);
    } else if (event is GetRejectedMeetingEvent) {
      yield* mapLoadRejectedMeeting(event);
    } else if (event is PostAcceptanceMeetingEvent) {
      yield* mapPostAcceptanceMeeting(event);
    } else if (event is GetAcceptedMeetingEvent) {
      yield* mapLoadAcceptedMeeting(event);
    } else if (event is UpdateMeetingEvent) {
      yield* mapUpdateMeeting(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
