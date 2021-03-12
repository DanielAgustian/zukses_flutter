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
      print("MeetingStateDetailSuccessLoad");
      yield MeetingStateDetailSuccessLoad(meeting: res);
    } else {
      yield MeetingStateFailLoad();
    }
  }

  Stream<MeetingState> mapUpdatingMeetingState(
      MeetingEventDidUpdated event) async* {
    yield MeetingStateSuccessLoad(meetings: event.meeting);
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
    }
  }
}
