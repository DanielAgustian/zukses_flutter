import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class LongButton extends StatelessWidget {
  const LongButton({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      textColor: textColor,
      color: bgColor,
      onPressed: onClick,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
      child: Container(
        width: size.width * 0.7,
        height: 40,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
