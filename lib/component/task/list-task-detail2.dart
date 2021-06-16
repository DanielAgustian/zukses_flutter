import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListTaskDetail2 extends StatelessWidget {
  ListTaskDetail2(
      {Key key,
      @required this.size,
      this.title,
      this.detail,
      this.date,
      this.hour,
      this.index = 1,
      this.onClick,
      this.priority,
      this.label})
      : super(key: key);
  final Size size;
  final String title, detail, date, hour, label;
  final int index;
  final Function onClick;
  final String priority;
  DateFormat dateFormat = DateFormat.yMMMMd();

  // border: Border(right: BorderSide(color: Colors.black, width: 1)),
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          width: size.width * 0.8,
          height: size.height < 600 ? size.height * 0.1 : size.height * 0.075,
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: colorPrimary),
                      ),
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(top: 3),
                      child: Text(detail,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontSize: 12, color: colorPrimary50)),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colorSecondaryYellow,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(label,
                        style: TextStyle(
                            color: colorBackground,
                            fontSize: size.height < 600 ? 10 : 12,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(
                  width: 0.015 * size.width,
                ),
                Container(
                  width: size.width * 0.04,
                  height: size.height,
                  decoration: BoxDecoration(
                      color: changePriorityColor(priority),
                      borderRadius: new BorderRadius.only(
                          bottomRight: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0))),
                )
              ])
            ],
          )),
    );
  }

  Color changePriorityColor(String val) {
    if (priority == null) {
      return colorPrimary;
    } else {
      if (val.toLowerCase() == "high") {
        return colorSecondaryRed;
      } else if (val.toLowerCase() == "medium") {
        return colorSecondaryYellow;
      } else if (val.toLowerCase() == "low") {
        return colorClear;
      } else {
        return colorPrimary;
      }
    }
  }
}
