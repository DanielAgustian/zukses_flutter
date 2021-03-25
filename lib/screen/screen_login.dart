import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/model/auth-model.dart';
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
    if (textPassword.text == "") {
      setState(() {
        _passValidator = true;
      });
    } else {
      setState(() {
        _passValidator = false;
      });
    }

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ScreenTab()),
            );

            //Failed Login
          } else if (state is AuthStateFailLoad) {
            setState(() {
              loading = false;
            });
            Util().showToast(
                context: this.context,
                msg: "Something Wrong !",
                color: colorError,
                txtColor: colorBackground);
          }
        },
        child: Scaffold(
            backgroundColor: colorBackground,
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Text(
                            "ZUKSES",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: colorPrimary, letterSpacing: 1.5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: size.width * 0.3),
                          LongButtonIcon(
                            size: size,
                            title: "Sign In with Google",
                            bgColor: colorGoogle,
                            textColor: colorBackground,
                            iconWidget: Image.asset(
                              'icon/google_icon.png',
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
                              'icon/facebook_icon.png',
                              scale: 0.6,
                            ),
                            onClick: () {},
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF8793B5)),
                          ),
                          SizedBox(height: 25),
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _usernameValidator
                                      ? Border.all(color: colorError)
                                      : Border.all(color: Colors.transparent),
                                  color: colorBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        color: Color.fromRGBO(240, 239, 242, 1),
                                        blurRadius: 15),
                                  ],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onChanged: (val) {},
                                controller: textUsername,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    hintText: "Username",
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
                                    : Border.all(color: Colors.transparent),
                                color: colorBackground,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Color.fromRGBO(240, 239, 242, 1),
                                      blurRadius: 15),
                                ],
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
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(20, 43, 111, 0.9),
                                    ),
                                    fontWeight: FontWeight.bold),
                              )),
                          SizedBox(height: 40),
                          LongButton(
                            loading: loading,
                            title: "Log In",
                            bgColor: colorPrimary,
                            textColor: colorBackground,
                            onClick: login,
                            size: size,
                          ),
                        ])))));
  }
}
