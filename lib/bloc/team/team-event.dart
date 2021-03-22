import 'package:equatable/equatable.dart';

import 'package:zukses_app_1/model/team-model.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  List<Object> get props => [];
}

// Load all employee data
class LoadAllTeamEvent extends TeamEvent {
  LoadAllTeamEvent();
  List<Object> get props => [];
}

class TeamEventDidUpdated extends TeamEvent {
  final List<TeamModel> team;
  const TeamEventDidUpdated(this.team);

  @override
  List<Object> get props => [team];
}