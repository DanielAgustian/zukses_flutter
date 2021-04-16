import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/team-service.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-event.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-state.dart';

class TeamDetailBloc extends Bloc<TeamDetailEvent, TeamDetailState> {
  StreamSubscription _subscription;

  final TeamServiceHTTP _teamServiceHTTP = TeamServiceHTTP();

  TeamDetailBloc() : super(null);

  @override
  Stream<TeamDetailState> mapEventToState(TeamDetailEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoadAllTeamDetailEvent) {
      yield* mapTeamDetail(event);
    }
  }

  Stream<TeamDetailState> mapTeamDetail(LoadAllTeamDetailEvent event) async* {
    yield TeamDetailStateLoading();
    // return list user model
    var res = await _teamServiceHTTP.fetchDetailTeam(event.id);

    
    
    // directly throw into success load or fail load
    if (res != null ) {
      yield TeamDetailStateSuccess(res);
    } else {
      yield TeamDetailStateFailed();
    }
  }
}
