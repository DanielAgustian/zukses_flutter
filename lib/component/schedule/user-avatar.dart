import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/component/avatar/avatar-medium.dart';
import 'package:zukses_app_1/component/avatar/avatar-small.dart';
import 'package:zukses_app_1/constant/constant.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key key, this.dotSize = 5, this.value, this.status})
      : super(key: key);

  final double dotSize;
  final String value;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Stack(
          children: [
            AvatarMedium25(imgUrl: value),
            if (status != null || status != "")
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: colorChangeStatus(status)),
                ),
              )
          ],
        ));
  }

  Color colorChangeStatus(String stat) {
    if (stat == null) {
      return colorSecondaryYellow;
    } else {
      if (stat.toLowerCase() == "yes") {
        return colorSecondaryRed;
      } else if (stat.toLowerCase() == "no") {
        return colorClear;
      } else {
        return Colors.transparent;
      }
    }
  }
}

class UserAvatarSchedule extends StatelessWidget {
  const UserAvatarSchedule(
      {Key key,
      this.dotSize = 6,
      this.avatarRadius = 10,
      this.value,
      this.status,
      this.imgURL})
      : super(key: key);

  final double dotSize, avatarRadius;
  final String value;
  final String status, imgURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: value == null
          ? Stack(
              children: [
                AvatarSmaller(
                  imgUrl: imgURL,
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

class UserAvatarScheduleBigger extends StatelessWidget {
  const UserAvatarScheduleBigger(
      {Key key,
      this.dotSize = 8,
      this.avatarRadius = 10,
      this.value,
      this.status,
      this.imgURL})
      : super(key: key);

  final double dotSize, avatarRadius;
  final String value;
  final String status, imgURL;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: value == null
          ? Stack(
              children: [
                AvatarMedium25(
                  imgUrl: imgURL,
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
              width: avatarRadius + 15,
              height: avatarRadius + 15,
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
