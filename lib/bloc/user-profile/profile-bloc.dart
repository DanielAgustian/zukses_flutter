import 'dart:async';
 
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:zukses_app_1/API/user-service.dart'; 
import 'package:zukses_app_1/bloc/user-profile/profile-event.dart';
import 'package:zukses_app_1/bloc/user-profile/profile-state.dart';
import 'package:zukses_app_1/model/user-model.dart'; 

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  StreamSubscription _subscription;
  final UserServiceHTTP _profileService = UserServiceHTTP();

  ProfileBloc() : super(null);

  // BLOC load user data by ID
  Stream<ProfileState> mapLoadUserData(GetProfileEvent event) async* {
    // return user model
    var res = await _profileService.getUserData(event.id);

    // directly throw into success load or fail load
    if (res is UserModel && res != null) {
      yield ProfileStateSuccessLoad(res);
    } else {
      yield ProfileStateFailed();
    }
  }

  // BLOC for update the state when the user doing event
  Stream<ProfileState> mapUpdatingProfileState(
      ProfileEventUpdated event) async* {
    yield ProfileStateSuccessLoad(event.user);
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetProfileEvent) {
      yield* mapLoadUserData(event);
    } else if (event is ProfileEventUpdated) {
      yield* mapUpdatingProfileState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
