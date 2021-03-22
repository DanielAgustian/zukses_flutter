import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class CommentBox extends StatelessWidget {
  CommentBox({
    Key key,
    this.user,
    this.comment,
    this.date,
    this.size,
  }) : super(key: key);

  final String user, comment;
  final String date;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Container(
                      width: size.width * 0.7,
                      child: Text(comment,
                          style: TextStyle(color: colorPrimary30))),
                ],
              )
            ],
          ),
          InkWell(
              onTap: () {},
              child: FaIcon(FontAwesomeIcons.ellipsisV, size: 16)),
        ],
      ),
    );
  }
}

class HistoryBox extends StatelessWidget {
  HistoryBox({
    Key key,
    this.user,
    this.history,
    this.date,
    this.size,
  }) : super(key: key);
  final String user, history;
  final DateTime date;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: colorBackground,
              boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 15,
                )
              ],
              borderRadius: BorderRadius.circular(5)),
          child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: size.height < 569 ? 12 : 14,
                color: colorPrimary,
              ),
              children: <TextSpan>[
                new TextSpan(
                    text: user, style: TextStyle(fontWeight: FontWeight.bold)),
                new TextSpan(
                    text: ' has done ',
                    style: new TextStyle(color: colorGoogle)),
                new TextSpan(
                    text: history,
                    style: TextStyle(fontWeight: FontWeight.w400)),
                new TextSpan(
                    text: " at ", style: TextStyle(color: colorGoogle)),
                TextSpan(
                    text: Util().hourFormat(date) +
                        ", " +
                        Util().yearFormat(date))
              ],
            ),
          )),
    );
  }
}
