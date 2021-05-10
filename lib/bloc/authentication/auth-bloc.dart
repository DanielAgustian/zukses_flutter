import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/model/facebook_auth-model.dart';
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
  Stream<AuthenticationState> mapLoginGoogle() async* {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

    String name, token, email, image;

    // try catch google sign in
    try {
      // get all data from google
      print("LOGIN GOOGLE ==============+> ON GOING . . .");
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await _googleSignIn.currentUser.authentication;

      name = _googleSignIn.currentUser.displayName;
      token = googleSignInAuthentication.idToken;
      email = _googleSignIn.currentUser.email;
      image = _googleSignIn.currentUser.photoUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("google", 1);

      print("GOOGLE LOGIN ==================+>");
      print(name);
      print(email);
      print(image);

      // Integrate to api backend
      // var res = await _authenticationService.loginGoogle(
      //     email: email,
      //     name: name,
      //     photo: image,
      //     tokenID: token,
      //     tokenFCM: event.fcmToken);

      // directly throw into success load or fail load
      // if (res != null && res is AuthModel) {
      //   // Save token and id user
      //   await prefs.setString("token", res.token);
      //   await prefs.setInt("userID", res.user.userID);

      //   // Save is user login via google or not
      //   await prefs.setString("via", "google");

      //   yield AuthStateSuccessLoad(res);
      // } else {
      //   yield AuthStateFailLoad();
      // }
    } catch (err) {
      print("Error Google Try Catch $err");
      yield AuthStateFailLoad();
    }
  }

  Stream<AuthenticationState> mapLoginFacebook(
      AuthEventWithFacebook event) async* {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("facebook", 1);
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login Canceled");

        break;
      case FacebookLoginStatus.error:
        print("RFecebook Login Error");

        break;
      default:
        break;
    }
    if (fbAuthData is FBAuthModel && fbAuthData != null) {
      yield AuthStateFacebookSuccessLoad(fbAuthData);
    } else {
      yield AuthStateFacebookFailLoad();
    }
  }

  // BLOC for login manually using email and password
  Stream<AuthenticationState> mapLoginManual(
      AuthEventLoginManual event) async* {
    // return auth model
    var res = await _authenticationService.createLogin(
        event.email, event.password, event.tokenFCM);

    // directly throw into success load or fail load
    if (res is AuthModel && res != null) {
      print("AuthStateSuccessLoad");
      yield AuthStateSuccessLoad(res);
    } else {
      print("AuthStateFailLoad");
      yield AuthStateFailLoad();
    }
  }

  Stream<AuthenticationState> mapLoginTeam(AuthEventLoginTeam event) async* {
    // return auth model
    var res = await _authenticationService.createLoginTeam(
        event.email, event.password, event.link);

    // directly throw into success load or fail load
    if (res is AuthModel && res != null) {
      print("AuthStateSuccessTeamLoad");
      yield AuthStateSuccessTeamLoad(res);
    } else {
      print("AuthStateFailLoad");
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
      yield* mapLoginGoogle();
    } else if (event is AuthEventLoginManual) {
      yield* mapLoginManual(event);
    } else if (event is AuthEventUpdated) {
      yield* mapUpdatingAuthState(event);
    } else if (event is AuthEventWithFacebook) {
      yield* mapLoginFacebook(event);
    } else if (event is AuthEventLoginTeam) {
      yield* mapLoginTeam(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
