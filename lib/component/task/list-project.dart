import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListProject extends StatelessWidget {
  ListProject({
    Key key,
    this.title,
    this.detail,
    this.jumlahTask,
  }) : super(key: key);

  final String title, detail;
  final int jumlahTask;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 14,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      detail,
                      style: TextStyle(fontSize: 12, color: colorPrimary50),
                    )
                  ],
                ),
                jumlahTask < 1
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                            color: colorSecondaryRed, shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            jumlahTask.toString(),
                            style: TextStyle(color: colorBackground),
                          ),
                        ))
              ],
            )));
  }
}
