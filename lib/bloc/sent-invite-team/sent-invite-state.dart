import 'package:equatable/equatable.dart';

abstract class SentInviteState extends Equatable {
  const SentInviteState();

  List<Object> get props => [];
}

class SentInviteStateFailed extends SentInviteState {}

class SentInviteStateSuccess extends SentInviteState {}

class SentInviteStateLoading extends SentInviteState {}