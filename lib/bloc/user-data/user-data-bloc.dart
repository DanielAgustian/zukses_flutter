import 'package:shared_preferences/shared_preferences.dart';
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("companyID", res.companyID);
      yield UserDataStateSuccessLoad(res);
    } else {
      yield UserDataStateFailLoad();
    }
  }

  Stream<UserDataState> mapUpdateProfile(
      UserDataUpdateProfileEvent event) async* {
    yield UserDataStateLoading();
    // return user model
    var res = await _userDataService.updateUserProfile(
        event.image, event.name, event.phone, event.link);
    // directly throw into success load or fail load
    if (res == 200) {
      yield UserDataStateUpdateSuccess(res);
    } else {
      yield UserDataStateUpdateFail();
    }
  }

  Stream<UserDataState> mapUpdatingUserDataState(
      UserDataEventDidUpdated event) async* {
    yield UserDataStateSuccessLoad(event.user);
  }

  // BLOC for handle notification changer
  Stream<UserDataState> mapNotificationChanger(
      UserChangeNotificationStatus event) async* {
    yield UserDataStateLoading();
    // return string message
    var res =
        await _userDataService.changeNotificationStatus(event.status ? 1 : 0);

    if (res != null && res != "") {
      yield (UserStateSuccessChangeNotif(msg: res));
    } else {
      yield UserDataStateUpdateFail();
    }
  }

  @override
  Stream<UserDataState> mapEventToState(UserDataEvent event) async* {
    if (event is UserDataGettingEvent) {
      yield* mapUserIn(event);
    } else if (event is UserDataEventDidUpdated) {
      yield* mapUpdatingUserDataState(event);
    } else if (event is UserDataUpdateProfileEvent) {
      yield* mapUpdateProfile(event);
    } else if (event is UserChangeNotificationStatus) {
      yield* mapNotificationChanger(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
