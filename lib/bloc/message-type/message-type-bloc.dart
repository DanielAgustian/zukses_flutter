import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/message-type-services.dart';

import 'message-type-event.dart';
import 'message-type-state.dart';

class MessageTypeBloc extends Bloc<MessageTypeEvent, MessageTypeState> {
  MessageTypeBloc() : super(null);
  StreamSubscription _subscription;
  MessageTypeServiceHTTP _messageTypeServicesHTTP = MessageTypeServiceHTTP();
  @override
  Stream<MessageTypeState> mapEventToState(MessageTypeEvent event) async* {
    if (event is GetMessageTypeEvent) {
      yield* mapGetMessageType(event);
    }
  }

  Stream<MessageTypeState> mapGetMessageType(GetMessageTypeEvent event) async* {
    yield MessageTypeStateLoading();
    var res = await _messageTypeServicesHTTP.fetchMessageType();
    if (res != null) {
      yield MessageTypeStateSuccess(res);
    } else {
      yield MessageTypeStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
