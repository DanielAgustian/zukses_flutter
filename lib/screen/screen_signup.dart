import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/model/register-model.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:zukses_app_1/screen/register/screen-setup.dart';

import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:recase/recase.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenSignUp extends StatefulWidget {
  ScreenSignUp({Key key, this.title, this.link}) : super(key: key);

  final String title;
  final Uri link;
  @override
  _ScreenSignUp createState() => _ScreenSignUp();
}

class _ScreenSignUp extends State<ScreenSignUp> with TickerProviderStateMixin {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  TextEditingController textConfirmPassword = new TextEditingController();
  TextEditingController textUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
  TextEditingController textEmail = new TextEditingController();

  bool _confirmPassValidator = false;
  bool _usernameValidator = false;
  bool _passValidator = false;
  bool _emailValidator = false;
  bool _linkValidator = false;
  List<bool> empty = [false, false, false, false];
  String failedRegister = "";
  String tokenFCM = "";

  void register() {
    if (textEmail.text == "") {
      setState(() {
        _emailValidator = true;
      });
    } else {
      print(textUsername.text.titleCase);
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);

      if (textEmail.text == "") {
        setState(() {
          empty[0] = true;
        });
      } else {
        if (!regex.hasMatch(textEmail.text)) {
          setState(() {
            _emailValidator = true;
          });
        } else {
          setState(() {
            _emailValidator = false;
          });
        }
      }
    }

    if (textUsername.text == "") {
      setState(() {
        empty[1] = true;
        _usernameValidator = true;
      });
    } else {
      setState(() {
        _usernameValidator = false;
      });
    }
    if (textPassword.text == "") {
      setState(() {
        empty[2] = true;
        _passValidator = true;
      });
    } else {
      setState(() {
        _passValidator = false;
      });
    }
    if (textConfirmPassword.text == "") {
      setState(() {
        empty[3] = true;
        _confirmPassValidator = true;
      });
    } else {
      if (textConfirmPassword.text != textPassword.text) {
        setState(() {
          _confirmPassValidator = true;

          _passValidator = true;
        });
      } else {
        setState(() {
          _confirmPassValidator = false;
        });
      }
    }

    if (widget.link == null) {
      setState(() {
        _linkValidator = true;
      });
    } else {
      setState(() {
        _linkValidator = false;
      });
    }
    if (!_emailValidator &&
        !_usernameValidator &&
        !_passValidator &&
        !_confirmPassValidator) {
      RegisterModel register = RegisterModel(
          email: textEmail.text.toLowerCase(),
          username: textUsername.text.titleCase,
          password: textPassword.text,
          confirmPassword: textConfirmPassword.text);

      if (_linkValidator) {
        registerIndividu(register);
      } else {
        registerTeamMember(register);
      }
    }
  }

  registerIndividu(RegisterModel register) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => _buildCupertino(
            context: context,
            wData: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email : " + textEmail.text.toLowerCase()),
                Text("Full Name: " + textUsername.text.titleCase),
              ],
            )));
    if (result) {
      BlocProvider.of<RegisterBloc>(context)
          .add(AddRegisterIndividuEvent(register, tokenFCM: tokenFCM));
    }
  }

  registerTeamMember(RegisterModel register) async {
    String link = await Util()
        .createDynamicLink2(short: false, link: widget.link.toString());
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => _buildCupertino(
            context: context,
            wData: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email : " + textEmail.text),
                Text("Full Name: " + textUsername.text.titleCase),
              ],
            )));
    if (result) {
      BlocProvider.of<RegisterBloc>(context)
          .add(AddRegisterTeamMemberEvent(register, link));
    }
  }

  gotoLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenLogin()),
    );
  }

  _sharedPrefLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userLogin", textEmail.text);
    await prefs.setString("passLogin", textPassword.text);
  }

  _getFCMToken() async {
    tokenFCM = await Util().getTokenFCM();
  }

  @override
  void initState() {
    super.initState();

    Util util = Util();

    util.initDynamicLinks(context);

    _getFCMToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      BlocListener<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterStateSuccess) {
                            _sharedPrefLogin();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetupRegister(
                                        token: state.authUser.token,
                                      )),
                            );
                          } else if (state is RegisterStateFailed) {
                            setState(() {
                              failedRegister =
                                  "Email already used. Please try another email.";
                              _emailValidator = true;
                            });
                          } else if (state is RegisterStateTeamMemberSuccess) {
                            _sharedPrefLogin();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisApproved()),
                                (route) => false);
                          }
                        },
                        child: Container(),
                      ),
                      TitleFormat(
                        size: size,
                        title: "welcome_text".tr() + "!",
                        detail: "register_text1".tr(),
                      ),
                      Form(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _emailValidator || empty[0]
                                      ? Border.all(color: colorError)
                                      : Border.all(color: colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  if (val.length > 0) {
                                    setState(() {
                                      empty[0] = false;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                controller: textEmail,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: _emailValidator
                                          ? colorError
                                          : colorNeutral1,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _usernameValidator || empty[1]
                                      ? Border.all(color: colorError)
                                      : Border.all(color: colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  if (val.length > 0) {
                                    setState(() {
                                      empty[1] = false;
                                    });
                                  }
                                },
                                controller: textUsername,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    hintText: "Full Name",
                                    hintStyle: TextStyle(
                                      color: _usernameValidator
                                          ? colorError
                                          : colorNeutral1,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _passValidator || empty[2]
                                      ? Border.all(color: colorError)
                                      : Border.all(color: colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                obscureText: _obscureText1,
                                textInputAction: TextInputAction.next,
                                onChanged: (val) {
                                  if (val.length > 0) {
                                    setState(() {
                                      empty[2] = false;
                                    });
                                  }
                                  if (val.length >= 0 && val.length < 6) {
                                    setState(() {
                                      _passValidator = true;
                                    });
                                  } else {
                                    setState(() {
                                      _passValidator = false;
                                    });
                                  }
                                },
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
                                          _obscureText1
                                              ? FontAwesomeIcons.solidEye
                                              : FontAwesomeIcons.solidEyeSlash,
                                          color: colorNeutral2,
                                          size: size.height < 569 ? 15 : 20),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText1 = !_obscureText1;
                                        });
                                      },
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _confirmPassValidator || empty[3]
                                      ? Border.all(color: colorError, width: 1)
                                      : Border.all(
                                          color: colorBorder, width: 1),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                obscureText: _obscureText2,
                                textInputAction: TextInputAction.go,
                                onChanged: (val) {
                                  if (val.length > 0) {
                                    setState(() {
                                      empty[3] = false;
                                    });
                                  }
                                },
                                controller: textConfirmPassword,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 20, top: 15),
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                      color: _confirmPassValidator
                                          ? colorError
                                          : colorNeutral1,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: FaIcon(
                                          _obscureText2
                                              ? FontAwesomeIcons.solidEye
                                              : FontAwesomeIcons.solidEyeSlash,
                                          color: colorNeutral2,
                                          size: size.height < 569 ? 15 : 20),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                    )),
                              ),
                            ),
                            empty[0] || empty[1] || empty[2] || empty[3]
                                ? Center(
                                    child: Text(
                                      "Please fill the textfield.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: colorError, fontSize: 10),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      failedRegister != ""
                                          ? Center(
                                              child: Text(
                                                failedRegister,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: colorError,
                                                    fontSize: 10),
                                              ),
                                            )
                                          : Container(),
                                      _passValidator &&
                                              textPassword.text.length < 6
                                          ? Center(
                                              child: Text(
                                                "Short password easy to guess. Try at least 6 characters.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: colorError,
                                                    fontSize: 13),
                                              ),
                                            )
                                          : Container(),
                                      _passValidator && _confirmPassValidator
                                          ? Center(
                                              child: Text(
                                                "Those passwords didn't match. Please make sure your password match.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: colorError,
                                                    fontSize: 10),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      LongButton(
                        title: "button_sign_up".tr(),
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        onClick: register,
                        size: size,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      /*Center(
                        child: Text(
                          "register_text2".tr(),
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF8793B5)),
                        ),
                      ),
                      SizedBox(height: 15),
                      LongButtonIcon(
                        size: size,
                        title: "button_sign_up_google".tr(),
                        bgColor: colorGoogle,
                        textColor: colorBackground,
                        iconWidget: Image.asset(
                          'assets/images/google-logo.png',
                          scale: 0.6,
                        ),
                        onClick: () {
                          BlocProvider.of<RegisterBloc>(context)
                              .add(AddRegisterGoogle(tokenFCM: tokenFCM));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButtonIcon(
                        size: size,
                        title: "button_sign_up_fb".tr(),
                        bgColor: colorFacebook,
                        textColor: colorBackground,
                        iconWidget: Image.asset(
                          'assets/images/facebook-logo.png',
                          scale: 0.6,
                        ),
                        onClick: () {
                          BlocProvider.of<RegisterBloc>(context)
                              .add(AddRegisterFacebook(tokenFCM: tokenFCM));
                        },
                      ),*/
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
                              new TextSpan(text: "register_text3".tr()),
                              TextSpan(
                                  text: ' ' + 'button_sign_in'.tr(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorPrimary),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      gotoLogin();
                                    }),
                            ],
                          ),
                        ),
                      ),
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {
                          if (state is AuthStateFacebookSuccessLoad) {
                            print(state.fbauth.email);
                          } else if (state is AuthStateFacebookFailLoad) {
                            print("Get Data from Facebook Failed");
                          } else {
                            print("No way going here -facebook");
                          }
                        },
                        child: Container(),
                      )
                    ]))));
  }

  Widget _buildCupertino({BuildContext context, Widget wData}) {
    return new CupertinoAlertDialog(
      title: new Text(
        "register_text4".tr(),
      ),
      content: wData,
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "no_text".tr(),
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        CupertinoDialogAction(
            child: Text(
              "yes_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ],
    );
  }
}
