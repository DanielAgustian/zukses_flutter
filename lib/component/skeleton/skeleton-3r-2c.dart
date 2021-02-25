import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

class Skeleton3R2C extends StatelessWidget {
  const Skeleton3R2C({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: colorNeutral150,
                blurRadius: 5,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    color: colorNeutral2,
                    width: size.height <= 570 ? 180 : 220,
                    height: 10,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    color: colorNeutral2,
                    width: size.height <= 570 ? 180 : 220,
                    height: 10,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                    color: colorNeutral2,
                    width: size.height <= 570 ? 180 : 220,
                    height: 10,
                  ),
                )
              ],
            ),
            Container(
              child: Row(
                children: [
                  SkeletonAnimation(
                    shimmerColor: colorNeutral170,
                    child: Container(
                      color: colorNeutral2,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SkeletonAnimation(
                    shimmerColor: colorNeutral170,
                    child: Container(
                      color: colorNeutral2,
                      width: 20,
                      height: 20,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
