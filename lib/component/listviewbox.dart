import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListViewBox extends StatelessWidget {
  ListViewBox({
    Key key,
    this.tasktitle,
    this.taskdetail,
  }) : super(key: key);

  final String tasktitle, taskdetail;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: colorBackground,
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
                        tasktitle,
                        style: TextStyle(fontSize: 14, color: colorPrimary),
                      ),
                    ),
                    Text(
                      taskdetail,
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
