import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-bloc.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-event.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-state.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/forgot-password/success-change.dart';
import 'package:zukses_app_1/util/util.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key, this.title, this.email, this.token})
      : super(key: key);
  final String title;
  final String email;
  final String token;
  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();
}

/// This is the stateless widget that the main application instantiates.
class _ResetPasswordScreen extends State<ResetPassword> {
  bool _obscureText = true;
  final textNewPassword = TextEditingController();
  final textConfirmPassword = TextEditingController();
  bool errorPassword = false;
  String token = "";
  _goTo() {
    print("button Clicked");
    if (textNewPassword.text == textConfirmPassword.text) {
      setState(() {
        errorPassword = false;
      });
    } else {
      setState(() {
        errorPassword = true;
      });
    }
    if (!errorPassword) {
      print("error password" + errorPassword.toString());
      print("token" + token);
      BlocProvider.of<ForgotPasswordBloc>(context)
          .add(SentNewPasswordEvent(textNewPassword.text, widget.token));
    }
  }

  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ForgotPasswordStateSuccess) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessChange()));
                    } else if (state is ForgotPasswordStateFailed) {
                      Util().showToast(
                          context: context,
                          color: colorError,
                          txtColor: colorBackground,
                          msg: "Reset Password goes wrong!",
                          duration: 3);
                    }
                  },
                  child: Container(),
                ),
                TitleFormat(
                  size: size,
                  title: "Reset Password",
                  detail: "Please input your new password",
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: errorPassword ? colorError : colorBorder),
                      color: colorBackground,
                      boxShadow: [boxShadowStandard],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.go,
                    onChanged: (val) {},
                    controller: textNewPassword,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, top: 15),
                        hintText: "New Password",
                        hintStyle: TextStyle(
                          color: errorPassword ? colorError : colorNeutral2,
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
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: errorPassword ? colorError : colorBorder),
                      color: colorBackground,
                      boxShadow: [boxShadowStandard],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.go,
                    onChanged: (val) {},
                    controller: textConfirmPassword,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, top: 15),
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          color: errorPassword ? colorError : colorNeutral2,
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
                  height: size.height < 569 ? 15 : 20,
                ),
                LongButton(
                  size: size,
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                  title: "Submit",
                  onClick: () {
                    _goTo();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
