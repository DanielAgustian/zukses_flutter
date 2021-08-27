import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/bloc/change-password/change-password-bloc.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/util/util.dart';

class ChangePasswordForm extends StatefulWidget {
  ChangePasswordForm();
  _ChangePasswordForm createState() => _ChangePasswordForm();
}

class _ChangePasswordForm extends State<ChangePasswordForm> {
  bool _obscureTextCurrent = false, _passwordCurrentValidator = false;
  bool _obscureTextNewPass = false, _newPassValidator = false;
  bool _obscureTextConfirm = false, _confirmPassValidator = false;
  bool _samenessPassValidator = false;
  bool _cannotSamePassValidator = false;

  final textPasswordController = TextEditingController();
  final textNewPassController = TextEditingController();
  final textConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [scaffoldForm(size, context), blocConsumer(size)],
    );
  }

  Widget blocConsumer(Size size) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        if (state is ChangePasswordStateLoading) {
          return loadingChangePassword(size);
        }
        return Container();
      },
      listener: (context, state) {
        if (state is ChangePasswordStateSuccess) {
          setState(() {
            _passwordCurrentValidator = true;
          });
          _loginSharedPref();
          showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupSuccess(context))
              .then((value) => Navigator.pop(context));
        } else if (state is ChangePasswordStateFailedDiffPass) {
          Util().showToast(
              duration: 3,
              context: context,
              msg: "change_password_text_12".tr(),
              color: colorError,
              txtColor: Colors.white);
        }
      },
    );
  }

  Widget loadingChangePassword(Size size) {
    return BackdropFilter(
      filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white.withOpacity(0),
        child: Column(
          children: [
            SizedBox(height: 200),
            CircularProgressIndicator(
              backgroundColor: colorPrimary70,
              valueColor: AlwaysStoppedAnimation(colorBackground),
            ),
            SizedBox(height: 10),
            Text(
              "Add meeting . .".tr(),
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget scaffoldForm(Size size, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "change_password_text_1".tr(),
          style: TextStyle(
              color: colorPrimary,
              fontSize: size.height < 570 ? 18 : 22,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: colorBackground,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            children: [
              //---------------------------Listener------------------

              //----------------------------------------------------
              SizedBox(
                height: 15,
              ),
              //Current password
              passwordWidget(
                  textPasswordController,
                  "change_password_text_2".tr(),
                  "change_password_text_3".tr(),
                  size,
                  _passwordCurrentValidator,
                  _obscureTextCurrent, onClickIcon: () {
                setState(() {
                  _obscureTextCurrent = !_obscureTextCurrent;
                });
              }),
              SizedBox(
                height: 20,
              ),
              //New password
              passwordWidget(
                  textNewPassController,
                  "change_password_text_4".tr(),
                  "change_password_text_5".tr(),
                  size,
                  _newPassValidator,
                  _obscureTextNewPass, onClickIcon: () {
                setState(() {
                  _obscureTextNewPass = !_obscureTextNewPass;
                });
              }),
              SizedBox(
                height: 20,
              ),
              //Confirm password
              passwordWidget(
                  textConfirmController,
                  "change_password_text_6".tr(),
                  "change_password_text_7".tr(),
                  size,
                  _confirmPassValidator,
                  _obscureTextConfirm, onClickIcon: () {
                setState(() {
                  _obscureTextConfirm = !_obscureTextConfirm;
                });
              }),
              wrongAlert(size),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 40,
              ),
              LongButton(
                title: "change_password_text_1".tr(),
                size: size,
                textColor: Colors.white,
                bgColor: colorPrimary,
                onClick: () {
                  _toChangePassword();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  //To make Password Widget + Title
  Widget passwordWidget(TextEditingController textEditingController,
      String title, String hint, Size size, bool _validator, bool _obscureText,
      {Function onClickIcon}) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: colorPrimary,
              fontSize: size.height < 569 ? 13 : 15,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        height: 42,
        decoration: BoxDecoration(
            border: _validator
                ? Border.all(color: colorError)
                : Border.all(color: colorBorder),
            color: colorBackground,
            boxShadow: [boxShadowStandard],
            borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          obscureText: _obscureText,
          textInputAction: TextInputAction.go,
          onChanged: (val) {},
          controller: textEditingController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, top: 6),
              hintText: hint,
              hintStyle: TextStyle(
                color: _validator ? colorError : colorNeutral1,
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
                  onPressed: onClickIcon)),
        ),
      ),
    ]);
  }

  Widget wrongAlert(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _samenessPassValidator
            ? Text(
                "change_password_text_8".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: colorError),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        _cannotSamePassValidator
            ? Center(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: size.width < 600 ? double.infinity : 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: colorError, width: 1),
                        color: colorBackgroundRed),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.19 - paddingHorizontal,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.exclamationTriangle,
                              size: 20,
                              color: colorError,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.79 - paddingHorizontal,
                          child: Center(
                            child: Text(
                              "change_password_text_9".tr(),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12, color: colorError),
                            ),
                          ),
                        )
                      ],
                    )),
              )
            : Container()
      ],
    );
  }

  _toChangePassword() {
    if (textConfirmController.text.length < 6) {
      setState(() {
        _confirmPassValidator = true;
      });
    } else {
      setState(() {
        _confirmPassValidator = false;
      });
    }
    print("_confirmPassValidator" + _confirmPassValidator.toString());
    if (textPasswordController.text.length < 6) {
      setState(() {
        _passwordCurrentValidator = true;
      });
    } else {
      setState(() {
        _passwordCurrentValidator = false;
      });
    }

    if (textNewPassController.text.length < 6) {
      setState(() {
        _newPassValidator = true;
      });
    } else {
      setState(() {
        _newPassValidator = false;
      });
    }
    if (textConfirmController.text != textNewPassController.text) {
      setState(() {
        _samenessPassValidator = true;
      });
    } else {
      setState(() {
        _samenessPassValidator = false;
      });
    }
    if (textNewPassController.text == textPasswordController.text) {
      setState(() {
        _cannotSamePassValidator = true;
      });
    } else {
      setState(() {
        _cannotSamePassValidator = false;
      });
    }
    if (!_passwordCurrentValidator &&
        !_newPassValidator &&
        !_confirmPassValidator &&
        !_samenessPassValidator &&
        !_cannotSamePassValidator) {
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupChangePassword(
                context,
              ));
    }
  }

  Widget _buildPopupChangePassword(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text(
        "change_password_text_10".tr(),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "cancel_text".tr(),
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        CupertinoDialogAction(
            child: Text("yes_text".tr()),
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<ChangePasswordBloc>(context).add(
                  ChangePasswordPostEvent(
                      password: textPasswordController.text,
                      newPassword: textNewPassController.text,
                      passwordConfirm: textConfirmController.text));
            })
      ],
    );
  }

  Widget _buildPopupSuccess(BuildContext context) {
    return CupertinoAlertDialog(
      title: new Text("success_text".tr() + "!"),
      content: new Text("change_password_text_11".tr()),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            })
      ],
    );
  }

  _loginSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("passLogin", textNewPassController.text);
  }
}
