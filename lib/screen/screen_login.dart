import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/widget/button/button-long-icon.dart';
import 'package:zukses_app_1/widget/button/button-long.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenLogin createState() => _ScreenLogin();
}

class _ScreenLogin extends State<ScreenLogin> {
  bool _obscureText = true;
  TextEditingController textUsername = new TextEditingController();
  TextEditingController textPassword = new TextEditingController();
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
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLogin()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButtonIcon(
                        size: size,
                        title: "Sign In with Google",
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
                                builder: (context) => ScreenLogin()),
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
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
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
                          keyboardType: TextInputType.emailAddress,
                          validator: (String val) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(val))
                              return 'Enter Valid Email';
                            else
                              return null;
                          },
                          onChanged: (val) {},
                          controller: textUsername,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              hintText: "Username",
                              hintStyle: TextStyle(
                                color: colorNeutral1,
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
                                color: colorNeutral1,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscureText
                                      ? FontAwesomeIcons.solidEye
                                      : FontAwesomeIcons.eye,
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
                        title: "Log In",
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenTab()),
                          );
                        },
                        size: size,
                      ),
                    ]))));
  }
}
