import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SmallButton extends StatelessWidget {
  const SmallButton(
      {Key key,
      this.onClick,
      this.title,
      this.bgColor,
      this.textColor,
      this.size = 100,
      this.loading = false})
      : super(key: key);

  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final double size;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: AnimatedContainer(
        width: loading ? 70 : size,
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  backgroundColor: textColor,
                  valueColor: AlwaysStoppedAnimation(bgColor),
                )
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
