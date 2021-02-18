import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListViewBoxMeeting extends StatelessWidget {
  ListViewBoxMeeting({
    Key key,
    this.meetingtitle,
    this.meetingdetail,
    this.status1,
    this.status2,
  }) : super(key: key);

  final String meetingtitle, meetingdetail, status1, status2;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: colorNeutral130,
              border: Border(
                bottom: BorderSide(width: 1.0, color: colorNeutral2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        meetingtitle,
                        style: TextStyle(fontSize: 14, color: colorPrimary),
                      ),
                    ),
                    Text(
                      meetingdetail,
                      style: TextStyle(fontSize: 12, color: colorNeutral2),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FaIcon(FontAwesomeIcons.tasks, color: colorSecondaryYellow),
                    SizedBox(width: 20),
                    FaIcon(
                      FontAwesomeIcons.tasks,
                      color: colorSecondaryRed,
                    )
                  ],
                )
              ],
            )));
  }
}
