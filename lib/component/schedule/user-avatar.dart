import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key key,
      this.dotSize = 5,
      this.avatarRadius = 10,
      this.value,
      this.status})
      : super(key: key);

  final double dotSize, avatarRadius;
  final String value;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: value == null
          ? Stack(
              children: [
                CircleAvatar(
                  backgroundColor: colorPrimary30,
                  radius: avatarRadius,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorChangeStatus(status)),
                  ),
                )
              ],
            )
          : Container(
              width: avatarRadius + 10,
              height: avatarRadius + 10,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: colorNeutral2),
              child: Center(
                child: Text(
                  "$value",
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Color colorChangeStatus(String stat) {
    if (stat == null) {
      return colorSecondaryYellow;
    } else {
      if (stat.toLowerCase() == "yes") {
        return colorSecondaryRed;
      } else if (stat.toLowerCase() == "no") {
        return colorClear;
      }
    }
  }
}

class UserAvatarSchedule extends StatelessWidget {
  const UserAvatarSchedule(
      {Key key,
      this.dotSize = 5,
      this.avatarRadius = 10,
      this.value,
      this.status})
      : super(key: key);

  final double dotSize, avatarRadius;
  final String value;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: value == null
          ? Stack(
              children: [
                CircleAvatar(
                  backgroundColor: colorPrimary30,
                  radius: avatarRadius,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorChangeStatus(status)),
                  ),
                )
              ],
            )
          : Container(
              width: avatarRadius + 10,
              height: avatarRadius + 10,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: colorNeutral2),
              child: Center(
                child: Text(
                  "$value",
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Color colorChangeStatus(String stat) {
    if (stat == null) {
      return colorSecondaryYellow;
    } else {
      if (stat.toLowerCase() == "accept") {
        return colorClear;
      } else if (stat.toLowerCase() == "pending") {
        return colorSecondaryYellow;
      } else if (stat.toLowerCase() == "reject") {
        return colorSecondaryRed;
      }
      return Colors.black;
    }
  }
}
