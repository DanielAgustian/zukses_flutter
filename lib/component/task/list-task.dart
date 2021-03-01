import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListTaskDetail extends StatelessWidget {
  ListTaskDetail({
    Key key,
    this.title,
    this.status,
  }) : super(key: key);

  final String title, status;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(
                    color: colorNeutral2.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: status == "done"
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: colorBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: colorPrimary)),
                                child: Center(
                                    child: Container(
                                  width: 5,
                                  height: 5,
                                  color: colorPrimary,
                                )))
                            : Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: colorBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1, color: colorPrimary)),
                              )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 6, 5, 10),
                      child: status == "done"
                          ? Text(
                              title,
                              style: TextStyle(
                                  color: colorPrimary,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Text(
                              title,
                              style: TextStyle(
                                color: colorPrimary,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ],
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colorSecondaryYellow,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            )));
  }
}
