import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-avatar.dart';

class SkeletonLess3WithAvatar extends StatelessWidget {
  SkeletonLess3WithAvatar({
    Key key,
    @required this.size,
    this.row = 2,
  }) : super(key: key);

  final Size size;
  final int row;

  final List<int> length = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
          SkeletonAnimation(
            shimmerColor: colorNeutral170,
            child: Container(
              decoration: BoxDecoration(
                color: colorSkeleton,
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width,
              height: 10,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          row == 2
              ? SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorSkeleton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: size.width,
                    height: 10,
                  ),
                )
              : Container(),
          SizedBox(
            height: 5,
          ),
          Container(
            width: size.width,
            child: Row(
              children: [
                ...length.map((item) => SkeletonAvatar(
                      radius: 20,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
