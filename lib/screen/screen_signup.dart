import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/component/button/button-long.dart';

class ScreenSignUp extends StatefulWidget {
  ScreenSignUp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenSignUp createState() => _ScreenSignUp();
}

class _ScreenSignUp extends State<ScreenSignUp> {
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

  void register() {
    if (textEmail.text == "") {
      setState(() {
        _emailValidator = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
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
    if (textConfirmPassword.text == "") {
      setState(() {
        _confirmPassValidator = true;
      });
    } else {
      if (textConfirmPassword.text != textPassword.text) {
        setState(() {
          _confirmPassValidator = true;
          _passValidator = true;
        });
      }
      setState(() {
        _confirmPassValidator = false;
      });
    }
    if (!_emailValidator &&
        !_usernameValidator &&
        !_passValidator &&
        !_confirmPassValidator) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenTab()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.04,
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
                        title: "Sign Up with Google",
                        bgColor: colorGoogle,
                        textColor: colorBackground,
                        iconWidget: Image.asset(
                          'icon/google_icon.png',
                          scale: 0.6,
                        ),
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenSignUp()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButtonIcon(
                        size: size,
                        title: "Sign Up with Google",
                        bgColor: colorFacebook,
                        textColor: colorBackground,
                        iconWidget: Image.asset(
                          'icon/facebook_icon.png',
                          scale: 0.6,
                        ),
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenSignUp()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "OR",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF8793B5)),
                      ),
                      SizedBox(height: 25),
                      Form(
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: _emailValidator
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
                                onChanged: (val) {},
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
                              ),
                            ),
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
                                obscureText: _obscureText1,
                                textInputAction: TextInputAction.next,
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
                                        _obscureText1
                                            ? FontAwesomeIcons.solidEye
                                            : FontAwesomeIcons.solidEyeSlash,
                                        color: colorNeutral2,
                                      ),
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
                                obscureText: _obscureText2,
                                textInputAction: TextInputAction.go,
                                onChanged: (val) {},
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
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText2 = !_obscureText2;
                                        });
                                      },
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      LongButton(
                        title: "Sign Up",
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        onClick: register,
                        size: size,
                      ),
                    ]))));
  }
}
