import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/facebook_auth-model.dart';
import 'package:zukses_app_1/model/google-sign-in-model.dart';

class AuthServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";
  final facebookLogin = FacebookLogin();

  Future<AuthModel> createLogin(String email, password, String tokenFCM) async {
    // print("tokenFCM" + tokenFCM);
    final response = await http.post(
      Uri.https(baseURI, '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'fcmToken': tokenFCM
      }),
    );
    // print("email: " + email);
    print("Create login : " + response.statusCode.toString());

    // print("response.body:" + response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      final user = AuthModel.fromJson(jsonDecode(response.body));

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      await prefs.setString("myID", user.user.userID);

      return user;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  Future<AuthModel> createLoginTeam(String email, password, link) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'invitationLink': link
      }),
    );
    // print("email: " + email);
    print("Login team : " + response.statusCode.toString());
    // print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //print("response.body:" + response.body);

      final user = AuthModel.fromJson(jsonDecode(response.body));

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      await prefs.setString("myID", user.user.userID);
      return user;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  void googleLogOut() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    _googleSignIn.signOut();
  }

  void fbLogOut() async {
    facebookLogin.logOut();
  }

  Future<GoogleSignInModel> googleSignIn() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      // print("LOGIN GOOGLE ==============+> ON GOING . . .");
      String name, token, email, image;
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await _googleSignIn.currentUser.authentication;

      name = _googleSignIn.currentUser.displayName;
      token = googleSignInAuthentication.idToken;
      email = _googleSignIn.currentUser.email;
      image = _googleSignIn.currentUser.photoUrl;

      // print("GOOGLE LOGIN ==================+>");
      GoogleSignInModel model = GoogleSignInModel(
          name: name, token: token, email: email, image: image);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("google", 1);
      await prefs.setString("google_data", jsonEncode(model));
      // print("Image Link in GoogleSIgnIN" + image);
      return model;
    } on Exception catch (e) {
      print("googleSignInFailed" + e.toString());
      return null;
    }
  }

  Future<AuthModel> googleLoginToAPI(
      String name, String email, String link_image, String token,
      {String tokenFCM, @required String provider}) async {
    try {
      // print("NAON ${tokenFCM}");
      // print("Image Link in GoogleLoginToAPI: " + link_image);
      final response = await http.post(
        Uri.https(baseURI, '/api/google-sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Charset': 'utf-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'name': name,
          'link_image': link_image,
          'token': token,
          'provider': provider,
          'fcmToken': tokenFCM
        }),
      );

      print("google login ${response.statusCode}");
      // print(response.body);
      final user = AuthModel.fromJson(jsonDecode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);
      await prefs.setString("myID", user.user.userID);
      return user;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }
  /*Future<FBAuthModel> fbLogin() async {
    final result = await facebookLogin.logIn(['email']);
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
          "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token",
        ));
        final profile = jsonDecode(graphResponse.body);
        FBAuthModel fbAuthData = FBAuthModel.fromJson(profile);
        return fbAuthData;
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login Canceled");
        return null;
        break;
      case FacebookLoginStatus.error:
        print("RFecebook Login Error");
        return null;
        break;
      default:
        return null;
        break;
    }
  }*/
}
