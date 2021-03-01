import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LongButtonIcon extends StatelessWidget {
  const LongButtonIcon({
    Key key,
    @required this.size,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.iconWidget,
  }) : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final Widget iconWidget;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(8.0),
      textColor: textColor,
      color: bgColor,
      onPressed: onClick,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Container(
        width: size.width,
        height: 40,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          iconWidget,
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ]),
      ),
    );
  }
}
