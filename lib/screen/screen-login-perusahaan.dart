import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

class LoginPerusahaan extends StatefulWidget {
  LoginPerusahaan({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenLoginPerusahaan createState() => _ScreenLoginPerusahaan();
}

class _ScreenLoginPerusahaan extends State<LoginPerusahaan> {
  bool _codeValidator = false;
  bool _check = false;
  bool _enable = true;
  TextEditingController textCompanyCode = new TextEditingController();
  String buttonText = "Check";
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
                  CircleAvatar(
                      backgroundColor: colorPrimary,
                      radius: size.width * 0.35,
                      child: Image.asset("assets/images/ava.png")),
                  SizedBox(height: 15),
                  Text(
                    "Input Company Code",
                    style: TextStyle(fontSize: 16, color: colorPrimary),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        color: colorBackground,
                        borderRadius: BorderRadius.circular(5),
                        border: _codeValidator
                            ? Border.all(color: colorError)
                            : Border.all(color: Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: colorNeutral1,
                            blurRadius: 5,
                          )
                        ]),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      enabled: _enable,
                      controller: textCompanyCode,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: _codeValidator
                              ? "Please Enter the Code"
                              : "Enter the Company Code",
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color:
                                  _codeValidator ? colorError : colorNeutral2)),
                    ),
                  ),
                  SizedBox(height: 20),
                  buttonText == "Check"
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: colorNeutral1,
                                  blurRadius: 5,
                                )
                              ]),
                          child: _codeValidator == true
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: colorPrimary,
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: Image.asset(
                                                          "assets/images/ava.png")
                                                      .image))),
                                      SizedBox(width: 20),
                                      Text("PT Yokesen Teknologi Indonesia")
                                    ],
                                  )),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  LongButtonOutline(
                    size: size,
                    title: buttonText,
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    onClick: () {
                      _check ? continueButton() : checkButton();

                      /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScreenLogin()),
                      );*/
                    },
                    outlineColor: colorPrimary,
                  ),
                ]))));
  }

  void checkButton() {
    if (textCompanyCode.text == "") {
      setState(() {
        _codeValidator = true;
      });
    } else {
      setState(() {
        _codeValidator = false;
      });
    }
    if (!_codeValidator) {
      setState(() {
        buttonText = "Confirm";
        _check = true;
        //_enable = false;
      });
    } else {
      setState(() {
        buttonText = "Check";
      });
    }
  }

  void continueButton() {
    setState(() {
      _check = false;
      _codeValidator = false;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenTab()));
  }
}
