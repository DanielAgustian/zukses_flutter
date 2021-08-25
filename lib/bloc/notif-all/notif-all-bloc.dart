import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/notification-navbar-services.dart';
import 'package:zukses_app_1/bloc/notif-all/notif-all-event.dart';
import 'package:zukses_app_1/bloc/notif-all/notif-all-state.dart';

class NotifAllBloc extends Bloc<NotifAllEvent, NotifAllState> {
  NotifAllBloc() : super(null);
  StreamSubscription _subscription;
  NotifNavServiceHTTP _NotifAllServicesHTTP = NotifNavServiceHTTP();
  @override
  Stream<NotifAllState> mapEventToState(NotifAllEvent event) async* {
    if (event is GetNotifForAllEvent) {
      yield* mapGetNotifAll(event);
    } else if (event is MarkNotifForAllEvent) {
      yield* mapMarkNotifAll(event);
    } else if (event is MarkNotifForOneEvent) {
      yield* mapMarkNotifForOne(event);
    }
  }

  Stream<NotifAllState> mapGetNotifAll(GetNotifForAllEvent event) async* {
    yield NotifAllStateLoading();
    var res = await _NotifAllServicesHTTP.fetchNotifAll();
    if (res != null) {
      if (res.length > 0) {
        yield NotifAllStateSuccessLoad(res);
      } else {
        yield NotifAllStateFailed();
      }
    } else {
      yield NotifAllStateFailed();
    }
  }

  Stream<NotifAllState> mapMarkNotifAll(MarkNotifForAllEvent event) async* {
    yield NotifAllStateLoading();
    var res = await _NotifAllServicesHTTP.readNotifAll();
    if (res != null) {
      if (res >= 200 && res < 300) {
        yield MarkNotifStateSuccess();
      } else {
        yield NotifAllStateFailed();
      }
    } else {
      yield NotifAllStateFailed();
    }
  }

  Stream<NotifAllState> mapMarkNotifForOne(MarkNotifForOneEvent event) async* {
    yield NotifAllStateLoading();
    var res = await _NotifAllServicesHTTP.readNotifOnce(event.notifId);
    if (res != null) {
      if (res >= 200 && res < 300) {
        yield MarkNotifStateSuccess();
      } else {
        yield NotifAllStateFailed();
      }
    } else {
      yield NotifAllStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
