import 'package:equatable/equatable.dart';


import 'package:zukses_app_1/model/team-model.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  List<Object> get props => [];
}

class TeamStateLoading extends TeamState {}

class TeamStateFailLoad extends TeamState {}

class TeamStateSuccessLoad extends TeamState {
  final List<TeamModel> team;

  TeamStateSuccessLoad({this.team});

  List<Object> get props => [team];

  @override
  String toString() {
    return 'Data : { employee List: $team }';
  }
}

