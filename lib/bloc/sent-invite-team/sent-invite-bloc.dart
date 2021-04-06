import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/sent-invitation-services.dart';
import 'package:zukses_app_1/bloc/sent-invite-team/sent-invite-event.dart';
import 'package:zukses_app_1/bloc/sent-invite-team/sent-invite-state.dart';

class SentInviteBloc extends Bloc<SentInviteEvent, SentInviteState> {
  SentInviteBloc() : super(null);
  SentInvitationServiceHTTP _sentInvitationServiceHTTP =
      SentInvitationServiceHTTP();

  StreamSubscription _subscription;
  @override
  Stream<SentInviteState> mapEventToState(SentInviteEvent event) async* {
    if (event is AddSentInviteEvent) {
      yield* mapSentInvite(event);
    }
  }

  Stream<SentInviteState> mapSentInvite(AddSentInviteEvent event) async* {
    yield SentInviteStateLoading();
    var res = await _sentInvitationServiceHTTP.sentInviteByEmail(
        event.email, event.idTeam);
    if (res == 200) {
      yield SentInviteStateSuccess();
    } else {
      yield SentInviteStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
