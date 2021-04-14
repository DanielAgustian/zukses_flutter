import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/model/facebook_auth-model.dart';

class AuthServiceHTTP {
  final baseURI = "api-zukses.yokesen.com";
  final fullBaseURI = "https://api-zukses.yokesen.com";
  final facebookLogin = FacebookLogin();
  //GoogleSignIn gsi = GoogleSignIn.standard();
  Future<AuthModel> createLogin(String email, password) async {
    final response = await http.post(
      Uri.https(baseURI, '/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Charset': 'utf-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    print("email: " + email);
    print("Auth Code: " + response.statusCode.toString());

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //print("response.body:" + response.body);

      final user = AuthModel.fromJson(jsonDecode(response.body));

      // Save token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", user.token);

      return user;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to login');
      return null;
    }
  }

  /*static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }*/

  /*loginWithGoogleSignIn() async {
    initializeFirebase();
    final user = await gsi.signIn();
    if (user != null) {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    }
  }*/
  void _fbLogOut() async {
    facebookLogin.logOut();
  }

  Future<FBAuthModel> fbLogin() async {
    final result = await facebookLogin.logIn(['email']);
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
          "https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token",
        ));
        final profile = jsonDecode(graphResponse.body);
        return FBAuthModel.fromJson(profile);
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Facebook Login Canceled");
        return null;
        break;
      case FacebookLoginStatus.error:
        print("RFecebook Login Error");
        return null;
        break;
    }
  }
}
