import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: must_be_immutable
class ListViewBox extends StatelessWidget {
  ListViewBox(
      {Key key,
      this.title,
      this.detail,
      this.status,
      this.size,
      @required this.onClick})
      : super(key: key);

  final String title, detail, status;
  final Size size;
  final Function onClick;
  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
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
                      title,
                      style: TextStyle(
                        fontSize: size.height < 569 ? 12 : 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 0.5 * size.width,
                    child: Text(
                      detail,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: size.height < 569 ? 10 : 12,
                          color: colorNeutral3),
                    ),
                  ),
                ],
              ),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: statusColor(status)),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.chevronUp,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }

  Color statusColor(String status) {
    status = status.toLowerCase();
    if (status == "high") {
      return colorError;
    } else if (status == "med") {
      return colorSecondaryYellow;
    } else {
      return colorClear;
    }
  }
}

class ListMeetingItem extends StatelessWidget {
  ListMeetingItem({
    Key key,
    this.title,
    this.detail,
    @required this.size,
    @required this.onClick
  }) : super(key: key);

  final String title, detail;
  final Size size;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
              color: colorBackground, boxShadow: [boxShadowStandard]),
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
                      title,
                      style: TextStyle(
                        fontSize: size.height < 569 ? 12 : 14,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    detail,
                    style: TextStyle(
                        fontSize: size.height < 569 ? 10 : 12,
                        color: colorNeutral2),
                  )
                ],
              ),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                size: size.height < 569 ? 22 : 26,
                color: colorPrimary,
              )
            ],
          )),
    );
  }
}

class ListProjectItem extends StatelessWidget {
  ListProjectItem(
      {@required this.title,
      @required this.lastWorked,
      @required this.status,
      @required this.percentage,
      @required this.onClick,
      @required this.size});
  final String title, status;
  final DateTime lastWorked;
  final double percentage;
  final Function onClick;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [boxShadowStandard], color: colorBackground),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: size.height < 569 ? 12 : 14,
                      color: Colors.black),
                ),
                Text(
                  status,
                  style: TextStyle(
                      color: statusColor(status),
                      fontSize: size.height < 569 ? 10 : 12),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Last Worked On - " + Util().dateNumbertoCalendar(lastWorked),
                style: TextStyle(
                    color: colorNeutral3,
                    fontSize: size.height < 569 ? 10 : 12),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 0.65 * size.width,
                  child: LinearPercentIndicator(
                    lineHeight: 15.0,
                    percent: percentage,
                    backgroundColor: colorNeutral1,
                    progressColor: colorPrimary,
                  ),
                ),
                Text(
                  stringPercentage(percentage),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.height < 569 ? 10 : 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String stringPercentage(double percentage) {
    double percent = percentage * 100;
    return percent.toString() + " %";
  }

  Color statusColor(String status) {
    String change = status.toLowerCase();
    if (change == "to do") {
      return colorSecondaryRed;
    } else if (change == "in progress") {
      return colorSecondaryYellow;
    } else {
      return colorClear;
    }
  }
}
