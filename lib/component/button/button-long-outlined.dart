import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          border: Border.all(color: outlineColor),
          color: bgColor,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor),
                  ),
          ),
        ),
      ),
    );
  }
}
