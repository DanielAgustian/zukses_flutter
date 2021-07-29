import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

class BoxHome extends StatelessWidget {
  const BoxHome(
      {Key key,
      this.title,
      this.total,
      this.fontSize = 14,
      this.bgColor,
      this.txtColor,
      this.loading = true})
      : super(key: key);

  final String title;
  final int total;
  final Color bgColor, txtColor;
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
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [boxShadowStandard]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  total.toString(),
                  style: TextStyle(
                      color: txtColor,
                      fontSize: fontSize + 24,
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
                    width: 20 ,
                    height: 10,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        title.split(" ")[0],
                        style: TextStyle(
                            color: txtColor,
                            fontSize: fontSize,
                            
                            letterSpacing: 0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        title.split(" ")[1],
                        style: TextStyle(
                            color: txtColor,
                            fontSize: fontSize,
                            
                            letterSpacing: 0),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
