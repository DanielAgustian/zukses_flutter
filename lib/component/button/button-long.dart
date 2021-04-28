import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class LongButton extends StatelessWidget {
  const LongButton(
      {Key key,
      @required this.size,
      this.onClick,
      this.title,
      this.bgColor,
      this.textColor,
      this.loading = false})
      : super(key: key);

  final Size size;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedContainer(
          width: size.width,
          duration: Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          height: size.height < 569 ? 30 : 40,
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
                        fontWeight: FontWeight.w700,
                        color: textColor),
                  ),
          ),
        ),
      ),
    );
  }
}

class LongButtonSize extends StatelessWidget {
  const LongButtonSize(
      {Key key,
      @required this.width,
      @required this.size,
      this.onClick,
      this.title,
      this.bgColor,
      this.textColor,
      this.clickable,
      this.loading = false})
      : super(key: key);

  final Size size;
  final double width;
  final Function onClick;
  final String title;
  final Color bgColor, textColor;
  final bool loading;
  final bool clickable;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        primary: bgColor,
        onSurface: clickable ? colorPrimary30 : Colors.transparent,
        onPrimary: clickable ? colorPrimary30 : Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
      ),
      onPressed: onClick,
      child: AnimatedContainer(
        width: width,
        duration: Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        height: size.height < 569 ? 30 : 40,
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
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
        ),
      ),
    );
  }
}
