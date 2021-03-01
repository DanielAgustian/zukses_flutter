import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    Key key,
    this.onClick,
    this.title,
    this.bgColor,
    this.textColor,
    this.size = 100,
  }) : super(key: key);

  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: size,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, color: textColor, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
