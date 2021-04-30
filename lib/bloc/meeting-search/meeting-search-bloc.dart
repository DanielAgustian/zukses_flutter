import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/meeting-services.dart';

import 'package:zukses_app_1/bloc/meeting-search/meeting-search-event.dart';
import 'package:zukses_app_1/bloc/meeting-search/meeting-search-state.dart';



class MeetingSearchBloc extends Bloc<MeetingSearchEvent, MeetingSearchState> {
  StreamSubscription _subscription;

  final MeetingServicesHTTP _meeting = MeetingServicesHTTP();

  MeetingSearchBloc() : super(null);
  
  // Bloc for loadd all MeetingSearch
  Stream<MeetingSearchState> mapAllMeetingSearch() async* {
    yield MeetingSearchStateLoading();
    // return list user model
    var res = await _meeting.fetchScheduleData();

 

    
    // directly throw into success load or fail load
    if (res.length > 0 && res != null) {
      
      yield MeetingSearchStateSuccessLoad(meeting: res);
    } else {
      yield MeetingSearchStateFailLoad();
    }
  }

  Stream<MeetingSearchState> mapUpdatingMeetingSearchState(
      MeetingSearchEventDidUpdated event) async* {
    yield MeetingSearchStateSuccessLoad(meeting: event.meeting);
  }

  @override
  Stream<MeetingSearchState> mapEventToState(MeetingSearchEvent event) async* {
    if (event is LoadAllMeetingSearchEvent) {
      yield* mapAllMeetingSearch();
    } else if (event is MeetingSearchEventDidUpdated) {
      yield* mapUpdatingMeetingSearchState(event);
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
