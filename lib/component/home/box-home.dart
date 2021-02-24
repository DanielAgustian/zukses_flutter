import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class BoxHome extends StatelessWidget {
  const BoxHome(
      {Key key, this.title, this.total, this.numberColor, this.fontSize = 36})
      : super(key: key);

  final String title;
  final int total;
  final Color numberColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: colorNeutral150,
              blurRadius: 5,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "8",
            style: TextStyle(
                color: numberColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
                color: colorPrimary,
                fontSize: fontSize - 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}
