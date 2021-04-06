import 'package:equatable/equatable.dart';

abstract class SentInviteEvent extends Equatable {
  const SentInviteEvent();

  List<Object> get props => [];
}

class AddSentInviteEvent extends SentInviteEvent {
  final String email;
  final String idTeam;
  AddSentInviteEvent(this.email, this.idTeam);
  List<Object> get props => [];
}
