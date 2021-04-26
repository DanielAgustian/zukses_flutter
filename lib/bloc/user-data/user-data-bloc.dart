import 'package:zukses_app_1/API/user-data-services.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  StreamSubscription _subscription;

  final UserDataServiceHTTP _userDataService = UserDataServiceHTTP();

  UserDataBloc() : super(null);

  Stream<UserDataState> mapUserIn(UserDataGettingEvent event) async* {
    yield UserDataStateLoading();
    // return user model
    var res = await _userDataService.fetchUserProfile();
    // directly throw into success load or fail load
    if (res is UserModel && res != null) {
      yield UserDataStateSuccessLoad(res);
    } else {
      yield UserDataFailLoad();
    }
  }

  Stream<UserDataState> mapUpdatingUserDataState(
      UserDataEventDidUpdated event) async* {
    yield UserDataStateSuccessLoad(event.user);
  }

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is UserDataGettingEvent) {
      yield* mapUserIn(event);
    } else if (event is UserDataEventDidUpdated) {
      yield* mapUpdatingUserDataState(event);
    }
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
