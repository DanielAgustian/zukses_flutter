import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class NotificationBox extends StatelessWidget {
  NotificationBox({this.title, this.date, this.size, this.onClick});
  final Size size;
  final String title;
  final DateTime date;
  final Function onClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorNeutral2, width: 1)),
          color: colorBackgroundBlue),
      child: InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
              decoration: BoxDecoration(
                  color: colorPrimary, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: FaIcon(FontAwesomeIcons.envelope,
                    color: colorBackground, size: 30),
              ),
            ),
            Container(
              width: size.width - 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.height < 569 ? 14 : 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Util().dateNumbertoCalendar(date) +
                        " at " +
                        Util().dateTimeToTimeOfDay(date),
                    style: TextStyle(
                      color: colorNeutral3,
                      fontSize: size.height < 569 ? 12 : 14,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
