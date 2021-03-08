import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';

class UserAssignedItem extends StatelessWidget {
  const UserAssignedItem({
    Key key,
    @required this.size,
    this.status,
    //this.onClick,
    this.index,
  }) : super(key: key);

  final Size size;
  final String status;

  //final Function onClick;
  final int index;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          children: [
            UserAvatar(
              avatarRadius: size.height <= 570 ? 10 : 15,
              dotSize: size.height <= 570 ? 6 : 8,
            ),
            SizedBox(width: 10),
            Text(
              "User $index ($status)",
              style: TextStyle(
                  color: colorPrimary, fontSize: size.height <= 570 ? 14 : 16),
            )
          ],
        ));
  }
}
