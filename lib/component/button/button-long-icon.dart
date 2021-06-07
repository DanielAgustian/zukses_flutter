import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class LongButtonIcon extends StatelessWidget {
  const LongButtonIcon({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.iconWidget,
    this.loading = false,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final Widget iconWidget;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: bgColor),
        child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [boxShadowStandard]),
          width: size.width,
          duration: Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          height: 35,
          child: loading
              ? CircularProgressIndicator(
                  backgroundColor: textColor,
                  valueColor: AlwaysStoppedAnimation(bgColor),
                )
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 25, height: 25, child: iconWidget),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  )
                ]),
        ),
      ),
    );
  }
}

class LongButtonIconShadow extends StatelessWidget {
  const LongButtonIconShadow({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.iconWidget,
    this.loading = false,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final Widget iconWidget;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  color: Color.fromRGBO(0, 0, 0, 0.25))
            ]),
        child: AnimatedContainer(
          decoration: BoxDecoration(boxShadow: [boxShadowStandard]),
          width: size.width,
          duration: Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          height: 35,
          child: loading
              ? CircularProgressIndicator(
                  backgroundColor: textColor,
                  valueColor: AlwaysStoppedAnimation(bgColor),
                )
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 25, height: 25, child: iconWidget),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  )
                ]),
        ),
      ),
    );
  }
}
