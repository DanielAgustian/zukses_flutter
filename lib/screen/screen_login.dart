import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/screen/forgot-password/forgot-password.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key, this.title, this.link}) : super(key: key);

  final String title;
  final Uri link;
  @override
  _ScreenLogin createState() => _ScreenLogin();
}

class _ScreenLogin extends State<ScreenLogin> with TickerProviderStateMixin {
  //Future<AuthModel> _futureLogin;
  String tokenFCM = "";
  bool _obscureText = true;
  AuthServiceHTTP authService = AuthServiceHTTP();
  TextEditingController textUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
  TextEditingController textUsernameScroll = new TextEditingController();
  TextEditingController textPasswordScroll = new TextEditingController();

  bool _usernameValidator = false;
  bool _passValidator = false;
  bool _userScrollValidator = false;
  bool _passScrollValidator = false;

  bool loading = false;
  bool errorLogin = false;

  List<bool> empty = [false, false, false, false];
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    super.initState();
    Util util = Util();
    util.initDynamicLinks(context);
    _controller = AnimationController(vsync: this, duration: _duration);
    // print("WidgetLink" + widget.link.toString());
    if (widget.link != null) {
      _controller.forward();
    }
    _getTokenFCM();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          //Success Login

          if (state is AuthStateSuccessLoad) {
            // print(state.authUser.user.email);
            // print(state.authUser.token);
            _loginSharedPref();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ScreenTab()),
              (Route<dynamic> route) => false,
            );
            //Failed Login
          } else if (state is AuthStateFailLoad) {
            // print("NANnananananan");
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
          } else if (state is AuthStateSuccessTeamLoad) {
            _loginTeamSharedPref();
            // print(state);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ScreenTab()),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: Scaffold(
            /*floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else if (_controller.isCompleted) _controller.reverse();
              },
            ),*/
            appBar: appBarOutside,
            backgroundColor: colorBackground,
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        alignment: Alignment.topCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleFormat(
                                size: size,
                                title: "welcome_text".tr() + "!",
                                detail: "login_text1".tr(),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
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
                                                : FontAwesomeIcons
                                                    .solidEyeSlash,
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
                                        style: TextStyle(
                                          fontSize: size.height < 569 ? 10 : 11,
                                          color: colorError,
                                        ))
                                    : Container(),
                              ),
                              SizedBox(
                                height: size.height < 569 ? 3 : 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        "login_text2".tr(),
                                        style: TextStyle(
                                          fontSize: size.height < 569 ? 10 : 11,
                                          color: colorPrimary70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height < 569 ? 5 : 10),
                              LongButton(
                                title: "button_sign_in".tr(),
                                bgColor: colorPrimary,
                                textColor: colorBackground,
                                onClick: login,
                                size: size,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: size.height < 569 ? 12 : 14,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      new TextSpan(text: "login_text4".tr()),
                                      TextSpan(
                                          text: 'button_sign_up'.tr(),
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
                            ]))),
                draggableScrollSheet(context, size)
              ],
            )));
  }

  Widget draggableScrollSheet(BuildContext context, Size size) {
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 1.0,
          maxChildSize: 1.0,
          builder: (BuildContext context, myscrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Color(0xFFFFFFFF),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleFormat(
                          size: size,
                          title: "welcome_text".tr() + "!",
                          detail: "login_text1".tr(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: InkWell(
                              onTap: () {
                                _controller.reverse();
                              },
                              child: FaIcon(FontAwesomeIcons.times,
                                  color: colorPrimary,
                                  size: size.height < 569 ? 20 : 25)),
                        ),
                      ],
                    ),
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: _userScrollValidator
                                ? Border.all(color: colorError)
                                : Border.all(color: colorBorder),
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {},
                          controller: textUsernameScroll,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: _userScrollValidator
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
                          border: _passScrollValidator
                              ? Border.all(color: colorError)
                              : Border.all(color: colorBorder),
                          color: colorBackground,
                          boxShadow: [boxShadowStandard],
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.go,
                        onChanged: (val) {},
                        controller: textPasswordScroll,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, top: 15),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: _passScrollValidator
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
                              style: TextStyle(
                                fontSize: size.height < 569 ? 10 : 11,
                                color: colorError,
                              ))
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
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Container(
                              child: Text(
                            "login_text2".tr(),
                            style: TextStyle(
                              fontSize: size.height < 569 ? 10 : 11,
                              color: colorPrimary70,
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
                      onClick: loginScroll,
                      size: size,
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
                            new TextSpan(text: "login_text4 ".tr()),
                            TextSpan(
                                text: ' ' + 'button_sign_up'.tr(),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --------------------------Logic-----------------------------//
  _gotoLoginTeam() async {
    String link = await Util()
        .createDynamicLink2(short: false, link: widget.link.toString());
    print(link);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginTeam(
        email: textUsernameScroll.text,
        password: textPasswordScroll.text,
        link: link));
  }

  void loginScroll() {
    setState(() {
      loading = true;
    });
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (textUsernameScroll.text == "" ||
        !regex.hasMatch(textUsernameScroll.text)) {
      setState(() {
        _userScrollValidator = true;
      });
    } else {
      setState(() {
        _userScrollValidator = false;
      });
    }
    if (textPasswordScroll.text == "" || textPasswordScroll.text.length < 6) {
      setState(() {
        _passScrollValidator = true;
      });
    } else {
      setState(() {
        _passScrollValidator = false;
      });
    }
    if (!_userScrollValidator && !_passScrollValidator) {
      _gotoLoginTeam();
    }
  }

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
          email: textUsername.text,
          password: textPassword.text,
          tokenFCM: tokenFCM));
    }
  }

  _loginTeamSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userLogin", textUsernameScroll.text);
    prefs.setString("passLogin", textPasswordScroll.text);
  }

  _loginSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userLogin", textUsername.text);
    prefs.setString("passLogin", textPassword.text);
  }

  void googleLogin() {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(AuthEventWithGoogle(tokenFCM: tokenFCM));

    setState(() {
      loading = true;
    });
  }

  void gotoRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenSignUp()));
  }

  _getTokenFCM() async {
    tokenFCM = await Util().getTokenFCM();
  }
}
