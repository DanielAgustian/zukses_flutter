import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/screen/forgot-password/forgot-password.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/button/button-long.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenLogin createState() => _ScreenLogin();
}

class _ScreenLogin extends State<ScreenLogin> {
  Future<AuthModel> _futureLogin;
  bool _obscureText = true;
  AuthServiceHTTP authService = AuthServiceHTTP();
  TextEditingController textUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
  bool _usernameValidator = false;
  bool _passValidator = false;
  bool loading = false;
  bool errorLogin = false;
  void login() {
    setState(() {
      loading = true;
    });
    if (textUsername.text == "") {
      setState(() {
        _usernameValidator = true;
      });
    } else {
      setState(() {
        _usernameValidator = false;
      });
    }
    if (textPassword.text == "" || textPassword.text.length < 6) {
      setState(() {
        _passValidator = true;
      });
    } else {
      setState(() {
        _passValidator = false;
      });
    }
    print("Validator = " +
        _usernameValidator.toString() +
        "," +
        _passValidator.toString());
    if (!_usernameValidator && !_passValidator) {
      BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginManual(
          email: textUsername.text, password: textPassword.text));

      // _futureLogin.then((data) {
      //   if (data != null) {
      //     if (data.token == null) {
      //       print("Token Null");
      //     }
      //     print("Token: " + data.token);
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ScreenTab()),
      //     );
      //   }
      // });
    }
  }

  timerLoading() {
    Duration time = Duration(seconds: 3);
    Timer _timer = new Timer.periodic(time, (timer) {
      setState(() {});
    });
  }

  _loginSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userLogin", textUsername.text);
    prefs.setString("passLogin", textPassword.text);
  }

  void googleLogin() {
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventWithGoogle());

    setState(() {
      loading = true;
    });
  }

  void gotoRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenSignUp()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          //Success Login

          if (state is AuthStateSuccessLoad) {
            print(state.authUser.user.email);
            print(state.authUser.token);
            _loginSharedPref();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ScreenTab()),
              (Route<dynamic> route) => false,
            );
            //Failed Login
          } else if (state is AuthStateFailLoad) {
            print("NANnananananan");
            setState(() {
              errorLogin = true;
              loading = false;
              _passValidator = true;
              _usernameValidator = true;
            });
            Util().showToast(
                context: this.context,
                msg: "Something Wrong !",
                color: colorError,
                txtColor: colorBackground);
          }
        },
        child: Scaffold(
            appBar: appBarOutside,
            backgroundColor: colorBackground,
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    alignment: Alignment.topCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleFormat(
                            size: size,
                            title: "Welcome!",
                            detail: "Sign in to Your Account",
                          ),
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _usernameValidator
                                      ? Border.all(color: colorError)
                                      : Border.all(color: colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onChanged: (val) {},
                                controller: textUsername,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: _usernameValidator
                                          ? colorError
                                          : colorNeutral1,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: _passValidator
                                    ? Border.all(color: colorError)
                                    : Border.all(color: colorBorder),
                                color: colorBackground,
                                boxShadow: [boxShadowStandard],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.go,
                              onChanged: (val) {},
                              controller: textPassword,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 20, top: 15),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: _passValidator
                                        ? colorError
                                        : colorNeutral1,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: FaIcon(
                                        _obscureText
                                            ? FontAwesomeIcons.solidEye
                                            : FontAwesomeIcons.solidEyeSlash,
                                        color: colorNeutral2,
                                        size: size.height < 569 ? 15 : 20),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  )),
                            ),
                          ),
                          errorLogin
                              ? SizedBox(
                                  height: 1,
                                )
                              : Container(),
                          Center(
                            child: errorLogin
                                ? Text("Wrong Email or Password",
                                    style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                      fontSize: size.height < 569 ? 10 : 11,
                                      color: colorError,
                                    )))
                                : Container(),
                          ),
                          SizedBox(
                            height: size.height < 569 ? 3 : 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: Container(
                                    child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: size.height < 569 ? 10 : 11,
                                      color: colorPrimary70,
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height < 569 ? 5 : 10),
                          LongButton(
                            loading: loading,
                            title: "Log In",
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                            onClick: login,
                            size: size,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Text(
                              "OR",
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF8793B5)),
                            ),
                          ),
                          SizedBox(height: 25),
                          LongButtonIcon(
                            size: size,
                            title: "Sign In with Google",
                            bgColor: colorGoogle,
                            textColor: colorBackground,
                            iconWidget: Image.asset(
                              'assets/images/google-logo.png',
                              scale: 0.6,
                            ),
                            onClick: () {},
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LongButtonIcon(
                            size: size,
                            title: "Sign In with Facebook",
                            bgColor: colorFacebook,
                            textColor: colorBackground,
                            iconWidget: Image.asset(
                              'assets/images/facebook-logo.png',
                              fit: BoxFit.contain,
                            ),
                            onClick: () {},
                          ),
                          SizedBox(
                            height: 0.02 * size.height,
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: size.height < 569 ? 12 : 14,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: "Doesn't have an account? "),
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: colorPrimary),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScreenSignUp()));
                                        }),
                                ],
                              ),
                            ),
                          )
                        ])))));
  }
}
