import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

class SkeletonLess3 extends StatelessWidget {
  const SkeletonLess3({
    Key key,
    @required this.size,
    this.row = 2,
    this.col = 1,
  }) : super(key: key);

  final Size size;
  final int row, col;

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
                row == 2
                    ? SkeletonAnimation(
                        shimmerColor: colorNeutral170,
                        child: Container(
                          color: colorNeutral2,
                          width: size.height <= 570 ? 180 : 220,
                          height: 10,
                        ),
                      )
                    : Container()
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
                  col == 2
                      ? SkeletonAnimation(
                          shimmerColor: colorNeutral170,
                          child: Container(
                            color: colorNeutral2,
                            width: 20,
                            height: 20,
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ));
  }
}
