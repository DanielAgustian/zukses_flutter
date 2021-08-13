import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/meeting-services.dart';

import 'meeting-rej-event.dart';
import 'meeting-rej-state.dart';




class MeetingRejBloc extends Bloc<MeetingRejEvent, MeetingRejState> {
  
  StreamSubscription _subscription;

  final MeetingServicesHTTP _scheduleServicesHTTP = MeetingServicesHTTP();

  MeetingRejBloc() : super(null);

  // Bloc for loadd all MeetingRej
  Stream<MeetingRejState> mapAllMeetingRej() async* {
    yield MeetingRejStateLoading();
    // return list user model
    var res = await _scheduleServicesHTTP.fetchRejectedScheduleData();

    // return checkbox handler
   
    
    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      
      yield MeetingRejStateSuccessLoad(meetings: res);
    } else {
      yield MeetingRejStateFailLoad();
    }
  }
  
  Stream<MeetingRejState> mapUpdatingMeetingRejState(
      MeetingRejEventDidUpdated event) async* {
    yield MeetingRejStateSuccessLoad(meetings: event.schedule);
  }

  @override
  Stream<MeetingRejState> mapEventToState(MeetingRejEvent event) async* {
    if (event is LoadAllMeetingRejEvent) {
      yield* mapAllMeetingRej();
    } else if (event is MeetingRejEventDidUpdated) {
      yield* mapUpdatingMeetingRejState(event);
    } 
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
