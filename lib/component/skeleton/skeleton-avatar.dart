import 'package:flutter/cupertino.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    Key key,
    this.radius = 40,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      shimmerColor: colorNeutral170,
      borderRadius: BorderRadius.circular(40),
      child: Container(
          height: radius,
          width: radius,
          decoration:
              BoxDecoration(color: colorSkeleton, shape: BoxShape.circle)),
    );
  }
}
