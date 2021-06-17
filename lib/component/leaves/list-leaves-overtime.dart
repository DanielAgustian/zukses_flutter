import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListLeavesOvertime extends StatelessWidget {
  ListLeavesOvertime(
      {Key key,
      this.title,
      this.detail,
      this.status,
      this.screen,
      this.onClick})
      : super(key: key);

  final String title, detail, screen;
  final String status;
  final Function onClick;
  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: InkWell(
          onTap: onClick,
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: colorBackground,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [boxShadowStandard]),
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
                        ],
                      ),
                    ],
                  ),
                  _buildText(context)
                ],
              )),
        ));
  }

  Widget _buildText(BuildContext context) {
    String textHasil = "";
    Color colorText;
    if (status == "pending") {
      textHasil = "Requested";
      colorText = colorSecondaryYellow;
    } else if (status == "accepted") {
      textHasil = "Accepted";
      colorText = colorClear;
    } else if (status == "rejected") {
      textHasil = "Rejected";
      colorText = colorError;
    }
    return Text(
      textHasil,
      style: TextStyle(
          color: colorText, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
  /*Widget _buildText(BuildContext context) {
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
  }*/
}
