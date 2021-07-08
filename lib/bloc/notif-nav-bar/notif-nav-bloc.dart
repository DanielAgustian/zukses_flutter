import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/notification-navbar-services.dart';

import 'notif-nav-event.dart';
import 'notif-nav-state.dart';

class NotifNavBloc extends Bloc<NotifNavEvent, NotifNavState> {
  NotifNavBloc() : super(null);
  StreamSubscription _subscription;
  NotifNavServiceHTTP _NotifNavServicesHTTP = NotifNavServiceHTTP();
  @override
  Stream<NotifNavState> mapEventToState(NotifNavEvent event) async* {
    if (event is GetNotifNavEvent) {
      yield* mapGetNotifNav(event);
    }
  }

  Stream<NotifNavState> mapGetNotifNav(GetNotifNavEvent event) async* {
    yield NotifNavStateLoading();
    var res = await _NotifNavServicesHTTP.fetchNotifNav();
    if (res != null) {
      yield NotifNavStateSuccess(res);
    } else {
      yield NotifNavStateFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
