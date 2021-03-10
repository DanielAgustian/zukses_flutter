import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zukses_app_1/constant/constant.dart';

class CommentBox extends StatelessWidget {
  CommentBox({
    Key key,
    this.user,
    this.comment,
    this.date,
  }) : super(key: key);

  final String user, comment;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration:
                    BoxDecoration(color: colorNeutral2, shape: BoxShape.circle),
              ),
              SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user,
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 20),
                      Text(date,
                          style: TextStyle(color: colorPrimary, fontSize: 12))
                    ],
                  ),
                  SizedBox(height: 5),
                  Column(
                    children: [
                      Text(comment, style: TextStyle(color: colorPrimary30)),
                    ],
                  )
                ],
              )
            ],
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.ellipsisV),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
