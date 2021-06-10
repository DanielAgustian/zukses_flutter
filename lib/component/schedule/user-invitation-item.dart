import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/component/avatar/avatar-medium.dart';
import 'package:zukses_app_1/constant/constant.dart';

class UserInvitationItem extends StatelessWidget {
  const UserInvitationItem({
    Key key,
    this.title,
    this.checkboxCallback,
    this.val, this.imgURL,
  }) : super(key: key);

  final String title, imgURL;
  final Function checkboxCallback;
  final bool val;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                AvatarMedium(
                  imgUrl:
                      imgURL
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 16,
                    color: colorPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Checkbox(
                value: val,
                activeColor: colorClear,
                checkColor: Colors.white,
                onChanged: (value) {
                  checkboxCallback(value);
                }),
          )
        ],
      ),
    );
  }
}
