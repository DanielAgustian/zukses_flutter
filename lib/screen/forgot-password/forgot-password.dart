
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zukses_app_1/bloc/forgot-password/forgot-password-bloc.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-event.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-state.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
import 'package:zukses_app_1/screen/forgot-password/check-your-email.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/util/util.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

/// This is the stateless widget that the main application instantiates.
class _ForgotPasswordScreen extends State<ForgotPassword> {
  final textEmail = TextEditingController();
  bool errorEmail = false;
  String _linkMessage = "";

  /*Future<void> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse(
          'https://zuksesapplication.page.link/forgotpassword?email=' +
              textEmail.text),
      androidParameters: AndroidParameters(
        packageName: 'com.example.zukses_app_1',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      print(_linkMessage);
    });
  }*/

  //Goto Next Page
  _goTo() {
    if (textEmail.text == "") {
      setState(() {
        errorEmail = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(textEmail.text)) {
        setState(() {
          errorEmail = false;
        });
      } else {
        setState(() {
          errorEmail = true;
        });
      }
    }

    if (!errorEmail) {
      //_createDynamicLink(false);
      _forgotPasswordProcess();
    }
  }

  _forgotPasswordProcess() async {
    String data =
        await Util().createDynamicLink(short: false, page: "forgotpassword");
    BlocProvider.of<ForgotPasswordBloc>(context)
        .add(SentLinkEvent(email: textEmail.text, dynamicLink: data));
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
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Center(
            child: Column(
              children: [
                BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordStateSuccess) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckEmail(
                                    email: textEmail.text,
                                  )));
                    }
                  },
                  child: Container(),
                ),
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
                      border: Border.all(
                          color: errorEmail ? colorError : colorBorder,
                          width: 1),
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
                          color: errorEmail ? colorError : colorNeutral2,
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
