import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LongButtonOutline extends StatelessWidget {
  const LongButtonOutline({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.outlineColor,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor, outlineColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      textColor: textColor,
      color: bgColor,
      onPressed: onClick,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: outlineColor, width: 1)),
      child: Container(
        width: size.width,
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
