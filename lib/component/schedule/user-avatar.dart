import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    this.dotSize = 5,
    this.avatarRadius = 10,
  }) : super(key: key);

  final double dotSize, avatarRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: colorSecondaryRed,
            radius: avatarRadius,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: colorClear),
            ),
          ),
        ],
      ),
    );
  }
}
