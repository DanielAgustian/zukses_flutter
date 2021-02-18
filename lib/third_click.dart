import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:zukses_app_1/widget/button/button-long-outlined.dart';
import 'package:zukses_app_1/widget/button/button-long.dart';
import 'package:zukses_app_1/widget/onboarding/onboarding-card.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ThirdPage createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "ZUKSES",
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: colorPrimary, letterSpacing: 1.5),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  OnBoardingCard(
                    size: size ,
                    title: "LOREM IPSUM",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
                    image: Image.asset("assets/images/ava.png"),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 7.0,
                            height: 7.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(128, 128, 128, 0.9),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 7.0,
                            height: 7.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(128, 128, 128, 0.9),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(20, 43, 111, 0.9),
                                shape: BoxShape.circle),
                          ),
                        ]),
                  ),
                  SizedBox(height: 15),
                  LongButton(
                      title: "Sign Up",
                      textColor: colorBackground,
                      bgColor: colorPrimary,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenSignUp()),
                        );
                      },
                      size: size),
                  SizedBox(height: 10),
                  LongButtonOutline(
                    size: size,
                    title: "Log In",
                    bgColor: colorBackground,
                    textColor: colorPrimary,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScreenLogin()),
                      );
                    },
                    outlineColor: colorPrimary,
                  ),
                ]))));
  }
}
