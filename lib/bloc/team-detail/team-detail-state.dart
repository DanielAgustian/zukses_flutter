import 'package:equatable/equatable.dart';
import 'package:zukses_app_1/model/team-detail-model.dart';

abstract class TeamDetailState extends Equatable {
  const TeamDetailState();

  List<Object> get props => [];
}

class TeamDetailStateSuccess extends TeamDetailState {
  final TeamDetailModel team;

  TeamDetailStateSuccess(this.team);
  List<Object> get props => [team];

  @override
  String toString() {
    return 'Data : { employee List: $team }';
  }
}

class TeamDetailStateFailed extends TeamDetailState {}

class TeamDetailStateLoading extends TeamDetailState {}