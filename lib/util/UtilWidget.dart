import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';

class UtilWidget {
  Widget _buildDebugDialog(
      BuildContext context, Size size, String message, String title) {
    return new CupertinoAlertDialog(
      title: new Text(
        "Debug " + title,
      ),
      content: new Text(message).tr(),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "yes_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
