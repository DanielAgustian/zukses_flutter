import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/API/team-service.dart';
import 'package:zukses_app_1/bloc/team/team-event.dart';
import 'package:zukses_app_1/bloc/team/team-state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  StreamSubscription _subscription;

  final TeamServiceHTTP _teamServiceHTTP = TeamServiceHTTP();

  TeamBloc() : super(null);

  // Bloc for loadd all Team
  Stream<TeamState> mapAllTeam() async* {
    yield TeamStateLoading();
    // return list user model
    try {
      var res = await _teamServiceHTTP.fetchTeamMember();

      // directly throw into success load or fail load
      if (res != null ) {
        yield TeamStateSuccessLoad(team: res);
      } else {
        print("MapAllTeamFailed");
        yield TeamStateFailLoad();
      }
    } catch (e) {
      print(e);
      yield TeamStateFailLoad();
    }
  }

  Stream<TeamState> mapUpdatingTeamState(TeamEventDidUpdated event) async* {
    yield TeamStateSuccessLoad(team: event.team);
  }

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    if (event is LoadAllTeamEvent) {
      yield* mapAllTeam();
    } else if (event is TeamEventDidUpdated) {
      yield* mapUpdatingTeamState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
