import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

AppBar customAppBar(BuildContext context,
    {Size size,
    String title,
    Widget leadingIcon,
    List<Widget> actionList,
    bool centerTitle: true}) {
  return AppBar(
    elevation: 0,
    backgroundColor: colorBackground,
    leading: leadingIcon,
    centerTitle: centerTitle,
    title: Text(
      "$title",
      style: TextStyle(
          color: colorPrimary,
          fontWeight: FontWeight.bold,
          fontSize: size.height <= 569 ? 20 : 25),
    ),
    actions: [...actionList.map((item) => item)],
  );
}
