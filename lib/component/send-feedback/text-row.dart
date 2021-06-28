import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TextRowSendFeedback extends StatelessWidget {
  const TextRowSendFeedback({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: fontSize,
                color: colorGoogle,
                fontWeight: FontWeight.w700),
          ),
          Text(
            textItem,
            style: TextStyle(
              fontSize: fontSize,
              color: colorStatus(textItem.toLowerCase()),
            ),
          )
        ],
      ),
    );
  }

  Color colorStatus(String text) {
    if (text == 'pending') {
      return colorSecondaryYellow;
    } else if (text == 'answered') {
      return colorClear;
    } else {
      return colorGoogle;
    }
  }
}
