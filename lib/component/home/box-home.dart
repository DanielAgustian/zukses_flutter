import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

class BoxHome extends StatelessWidget {
  const BoxHome(
      {Key key,
      this.title,
      this.total,
      this.numberColor,
      this.fontSize = 36,
      this.loading = true})
      : super(key: key);

  final String title;
  final int total;
  final Color numberColor;
  final double fontSize;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.07;
    return Container(
      width: size.width / 2 - padding,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorNeutral150,
              blurRadius: 5,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loading
              ? SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSkeleton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 20,
                    height: 30,
                  ),
                )
              : Text(
                  "8",
                  style: TextStyle(
                      color: numberColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0),
                ),
          SizedBox(height: 5),
          loading
              ? SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSkeleton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 80,
                    height: 10,
                  ),
                )
              : Text(
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
