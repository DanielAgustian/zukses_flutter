import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class ListTaskDetail2 extends StatelessWidget {
  ListTaskDetail2({
    Key key,
    @required this.size,
    this.title,
    this.detail,
    this.date,
    this.hour,
    this.index = 1,
  }) : super(key: key);
  final Size size;
  final String title, detail, date, hour;
  final int index;

  DateFormat dateFormat = DateFormat.yMMMMd();
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
            width: size.width * 0.8,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: colorNeutral1.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: colorBackground,
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: colorPrimary)),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Text(detail,
                              style: TextStyle(
                                  fontSize: 11, color: colorPrimary50)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Due Date   :",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                            SizedBox(
                              width: 10,
                            ),
                            Text(date,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black)),
                            SizedBox(width: 10),
                            Text(hour,
                                style: TextStyle(
                                    fontSize: 11, color: Colors.black))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colorNeutral2,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(" +Tag  ",
                        style: TextStyle(
                            color: Color.fromRGBO(14, 77, 164, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10),
                  Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: colorSecondaryRed,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.angleUp,
                          color: colorBackground,
                        ),
                      ))
                ])
              ],
            )));
  }
}
