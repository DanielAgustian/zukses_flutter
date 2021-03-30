import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/forgot-password/success-change.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();
}

/// This is the stateless widget that the main application instantiates.
class _ResetPasswordScreen extends State<ResetPassword> {
  bool _obscureText = true;
  final textNewPassword = TextEditingController();
  final textConfirmPassword = TextEditingController();
  _goTo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SuccessChange()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleFormat(
                  size: size,
                  title: "Reset Password",
                  detail: "Please input your new password",
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: colorBorder),
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
                          color: colorNeutral2,
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
                      border: Border.all(color: colorBorder),
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
                          color: colorNeutral2,
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
