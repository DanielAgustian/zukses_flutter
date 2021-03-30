import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
import 'package:zukses_app_1/screen/forgot-password/check-your-email.dart';
import 'package:zukses_app_1/screen/screen_login.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

/// This is the stateless widget that the main application instantiates.
class _ForgotPasswordScreen extends State<ForgotPassword> {
  final textEmail = TextEditingController();

  _goTo() {
    if (textEmail.text == "") {
      print("Error Data");
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CheckEmail()));
  }

  gotoLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenLogin()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              children: [
                TitleFormat(
                  size: size,
                  title: "Forgot Password",
                  detail:
                      "Please Enter Your Email Address  and we will send you instruction to reset your password",
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colorBorder, width: 1),
                      color: colorBackground,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onChanged: (val) {},
                    controller: textEmail,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: colorNeutral2,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                SizedBox(height: size.height < 569 ? 10 : 15),
                LongButton(
                  size: size,
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                  title: "Submit",
                  onClick: () {
                    _goTo();
                  },
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: size.height < 569 ? 12 : 14,
                            color: Colors.black),
                        children: [
                      TextSpan(text: "Back to "),
                      TextSpan(
                          text: "Login",
                          style: TextStyle(
                              color: colorPrimary, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              gotoLogin();
                            })
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
