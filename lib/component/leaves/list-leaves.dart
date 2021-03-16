import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListLeavesInside extends StatelessWidget {
  ListLeavesInside({Key key, this.title, this.detail, this.status, this.screen})
      : super(key: key);

  final String title, detail, screen;
  final int status;
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 6, 5, 10),
                          child: Text(
                            title,
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 6, 5, 5),
                          child: Text(
                            detail,
                            style: TextStyle(
                              color: colorPrimary50,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        screen == "leaves"
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(5, 6, 5, 5),
                                child: Text(
                                  "19.00-20.00",
                                  style: TextStyle(
                                    color: colorPrimary50,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                _buildText(context)
              ],
            )));
  }

  Widget _buildText(BuildContext context) {
    String textHasil = "";
    Color colorText;
    if (status == 0) {
      textHasil = "Requested";
      colorText = colorSecondaryYellow;
    } else if (status == 1) {
      textHasil = "Approval";
      colorText = colorClear;
    } else if (status == 2) {
      textHasil = "Rejected";
      colorText = colorError;
    }
    return Text(
      textHasil,
      style: TextStyle(
          color: colorText, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
