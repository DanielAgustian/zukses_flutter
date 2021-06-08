import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/API/register-services.dart';

import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/facebook_auth-model.dart';
import 'package:zukses_app_1/model/fb_model_sender.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(null);
  RegisterServicesHTTP _registerServicesHTTP = RegisterServicesHTTP();
  AuthServiceHTTP _authenticationService = AuthServiceHTTP();
  StreamSubscription _subscription;
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is AddRegisterIndividuEvent) {
      yield* mapAddRegisIndividual(event);
    } else if (event is AddRegisterTeamEvent) {
      yield* mapAddRegisTeam(event);
    } else if (event is AddRegisterCompanyEvent) {
      yield* mapAddRegisCompany(event);
    } else if (event is AddRegisterTeamMemberEvent) {
      yield* mapAddRegisTeamMember(event);
    } else if (event is PostAcceptanceCompanyEvent) {
      yield* mapRegisterIntoCompanyAcceptance(event);
    } else if (event is AddRegisterFacebook) {
      yield* mapRegisterFacebook(event);
    } else if (event is AddRegisterGoogle) {
      yield* mapAddRegisGoogle(event);
    }
  }

  Stream<RegisterState> mapAddRegisIndividual(
      AddRegisterIndividuEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP
        .createRegisterIndividual(event.register, tokenFCM: event.tokenFCM);
    if (res != null) {
      yield RegisterStateSuccess(res);
    } else {
      yield RegisterStateFailed();
    }
  }

  Stream<RegisterState> mapAddRegisGoogle(AddRegisterGoogle event) async* {
    yield RegisterStateLoading();

    try {
      var googleData = await _authenticationService.googleSignIn();

      // Integrate to api backend
      var res = await _authenticationService.googleLoginToAPI(
          googleData.name, googleData.email, googleData.image, googleData.token,
          tokenFCM: event.tokenFCM);
      if (res != null && res is AuthModel) {
        yield RegisterStateSuccess(res);
      } else {
        yield RegisterStateFailed();
      }
    } catch (err) {
      yield RegisterStateFailed();
    }
  }

  Stream<RegisterState> mapRegisterFacebook(AddRegisterFacebook event) async* {
    yield RegisterStateLoading();
    FBAuthModel fbAuthData = FBAuthModel();

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    String tokenFacebook = "";
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        tokenFacebook = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
          "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$tokenFacebook",
        ));
        final profile = jsonDecode(graphResponse.body);
        fbAuthData = FBAuthModel.fromJson(profile);
        var res = await _authenticationService.googleLoginToAPI(fbAuthData.name,
            fbAuthData.email, fbAuthData.picture.url, tokenFacebook,
            tokenFCM: event.tokenFCM);
        FBModelSender fms = FBModelSender(
            email: fbAuthData.email,
            name: fbAuthData.name,
            url: fbAuthData.picture.url,
            id: fbAuthData.id);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("facebook", 1);
        await prefs.setString("facebook_token", tokenFacebook);
        await prefs.setString("facebook_data", jsonEncode(fms));
        if (res is AuthModel && res != null) {
          yield RegisterStateSuccess(res);
          // print("AuthStateSuccess FAcebook");
          // print(state);
        } else {
          yield RegisterStateFailLoad();
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login Canceled");
        yield RegisterStateFailLoad();
        break;
      case FacebookLoginStatus.error:
        print("RFecebook Login Error");
        yield RegisterStateFailLoad();
        break;
      default:
        break;
    }
    if (fbAuthData is FBAuthModel && fbAuthData != null) {
      //yield RegisterStateSuccess();
    } else {
      yield RegisterStateFailed();
    }
  }

  Stream<RegisterState> mapRegisterIntoCompanyAcceptance(
      PostAcceptanceCompanyEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.postAcceptanceToCompany();
    if (res == 200) {
      yield RegisterStateAccCompanySuccess(res);
    } else {
      yield RegisterStateAccCompanyFailed();
    }
  }

  Stream<RegisterState> mapAddRegisTeamMember(
      AddRegisterTeamMemberEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterTeamMember(
        event.register, event.link);
    if (res != null) {
      yield RegisterStateTeamMemberSuccess(res);
    } else {
      yield RegisterStateTeamMemberFailed();
    }
  }

  Stream<RegisterState> mapAddRegisTeam(AddRegisterTeamEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterTeam(
        event.token, event.namaTeam, event.link, event.email);
    if (res != null) {
      yield RegisterStateTeamSuccess(res);
    } else {
      yield RegisterStateTeamFailed();
    }
  }

  Stream<RegisterState> mapAddRegisCompany(
      AddRegisterCompanyEvent event) async* {
    yield RegisterStateLoading();
    var res = await _registerServicesHTTP.createRegisterToCompany(
        event.token, event.kode);

    print("AddRegisCompanyEvent" + res.toString());
    if (res == 200) {
      yield RegisterStateCompanySuccess(res);
    } else {
      yield RegisterStateCompanyFailed();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
