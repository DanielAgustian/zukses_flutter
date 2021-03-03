import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class LongButtonOutline extends StatelessWidget {
  const LongButtonOutline({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.outlineColor,
    this.loading = false,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor, outlineColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      textColor: textColor,
      color: bgColor,
      onPressed: onClick,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: outlineColor)),
      child: AnimatedContainer(
        width: loading ? 100 : size.width,
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        height: 40,
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  backgroundColor: textColor,
                  valueColor: AlwaysStoppedAnimation(bgColor),
                )
              : Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
