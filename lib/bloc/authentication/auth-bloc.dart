import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/model/facebook_auth-model.dart';
import 'package:zukses_app_1/model/fb_model_sender.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';
import 'package:zukses_app_1/model/auth-model.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  StreamSubscription _subscription;
  final AuthenticationRepository _authenticationRepository;

  final AuthServiceHTTP _authenticationService = AuthServiceHTTP();

  AuthenticationBloc({@required AuthenticationRepository authRepo})
      : assert(authRepo != null),
        _authenticationRepository = authRepo,
        super(AuthStateLoading());

  // BLOC for login with google
  Stream<AuthenticationState> mapLoginGoogle(AuthEventWithGoogle event) async* {
    // try catch google sign in
    yield AuthStateLoading();
    try {
      // get all data from google
      var googleData = await _authenticationService.googleSignIn();

      // Integrate to api backend
      var res = await _authenticationService.googleLoginToAPI(
          googleData.name, googleData.email, googleData.image, googleData.token,
          tokenFCM: event.tokenFCM, provider: 'google');
      if (res is AuthModel && res != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("in-company", res.user.companyAcceptance);
        prefs.setString("company_id", res.user.companyID);
        yield AuthStateSuccessLoad(res);
      } else {
        yield AuthStateFailLoad();
      }
    } catch (err) {
      print("Error Google Try Catch $err");
      yield AuthStateFailLoad();
    }
  }

  Stream<AuthenticationState> mapLoginFacebook(
      AuthEventWithFacebook event) async* {
    yield AuthStateLoading();

    FBAuthModel fbAuthData = FBAuthModel();

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    String tokenFacebook = "";
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
            tokenFCM: event.tokenFCM, provider: 'facebook');
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("in-company", res.user.companyAcceptance);
          prefs.setString("company_id", res.user.companyID);
          yield AuthStateSuccessLoad(res);
        } else {
          yield AuthStateFailLoad();
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login Canceled");
        yield AuthStateFailLoad();
        break;
      case FacebookLoginStatus.error:
        print("RFecebook Login Error");
        yield AuthStateFailLoad();
        break;
      default:
        break;
    }
  }

  // BLOC for login manually using email and password
  Stream<AuthenticationState> mapLoginManual(
      AuthEventLoginManual event) async* {
    yield AuthStateLoading();
    // return auth model
    var res = await _authenticationService.createLogin(
        event.email, event.password, event.tokenFCM);

    // directly throw into success load or fail load
    if (res is AuthModel && res != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("in-company", res.user.companyAcceptance);
      prefs.setString("company_id", res.user.companyID);
      yield AuthStateSuccessLoad(res);
    } else {
      yield AuthStateFailLoad();
    }
  }

  Stream<AuthenticationState> mapAuthDetectGoogle(
      AuthEventDetectGoogleSignIn event) async* {
    var res = await _authenticationService.googleLoginToAPI(
        event.name, event.email, event.image, event.tokenGoogle,
        tokenFCM: event.tokenFCM, provider: 'google');
    if (res is AuthModel && res != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("in-company", res.user.companyAcceptance);
      prefs.setString("company_id", res.user.companyID);
      yield AuthStateSuccessLoad(res);
    } else {
      yield AuthStateFailLoad();
    }
  }

  Stream<AuthenticationState> mapLoginTeam(AuthEventLoginTeam event) async* {
    yield AuthStateLoading();
    // return auth model
    var res = await _authenticationService.createLoginTeam(
        event.email, event.password, event.link);

    // directly throw into success load or fail load
    if (res is AuthModel && res != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("in-company", res.user.companyAcceptance);
      prefs.setString("company_id", res.user.companyID);
      yield AuthStateSuccessTeamLoad(res);
    } else {
      yield AuthStateFailLoad();
    }
  }

  // BLOC for update the state when the user doing event
  Stream<AuthenticationState> mapUpdatingAuthState(
      AuthEventUpdated event) async* {
    yield AuthStateSuccessLoad(event.user);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthEventWithGoogle) {
      yield* mapLoginGoogle(event);
    } else if (event is AuthEventLoginManual) {
      yield* mapLoginManual(event);
    } else if (event is AuthEventUpdated) {
      yield* mapUpdatingAuthState(event);
    } else if (event is AuthEventWithFacebook) {
      yield* mapLoginFacebook(event);
    } else if (event is AuthEventLoginTeam) {
      yield* mapLoginTeam(event);
    } else if (event is AuthEventDetectGoogleSignIn) {
      yield* mapAuthDetectGoogle(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
