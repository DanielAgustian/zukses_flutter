import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/team-detail-model.dart';

abstract class TeamDetailEvent extends Equatable {
  const TeamDetailEvent();

  List<Object> get props => [];
}

class LoadAllTeamDetailEvent extends TeamDetailEvent {
  final String id;
  LoadAllTeamDetailEvent(this.id);
  List<Object> get props => [id];
}

class TeamDetailEventDidUpdated extends TeamDetailEvent {
  final List<TeamDetailModel> team;
  const TeamDetailEventDidUpdated(this.team);

  @override
  List<Object> get props => [team];
}
