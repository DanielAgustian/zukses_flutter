import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/meeting-services.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-event.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-state.dart';



class MeetingReqBloc extends Bloc<MeetingReqEvent, MeetingReqState> {
  StreamSubscription _subscription;

  final MeetingServicesHTTP _scheduleServicesHTTP = MeetingServicesHTTP();

  MeetingReqBloc() : super(null);

  // Bloc for loadd all MeetingReq
  Stream<MeetingReqState> mapAllMeetingReq() async* {
    yield MeetingReqStateLoading();
    // return list user model
    var res = await _scheduleServicesHTTP.fetchUnresponseScheduleData();

    // return checkbox handler
   
    
    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      
      yield MeetingReqStateSuccessLoad(schedule: res);
    } else {
      yield MeetingReqStateFailLoad();
    }
  }
  
  Stream<MeetingReqState> mapUpdatingMeetingReqState(
      MeetingReqEventDidUpdated event) async* {
    yield MeetingReqStateSuccessLoad(schedule: event.schedule);
  }

  @override
  Stream<MeetingReqState> mapEventToState(MeetingReqEvent event) async* {
    if (event is LoadAllMeetingReqEvent) {
      yield* mapAllMeetingReq();
    } else if (event is MeetingReqEventDidUpdated) {
      yield* mapUpdatingMeetingReqState(event);
    } 
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
