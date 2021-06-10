import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/avatar/avatar-medium.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

// ignore: must_be_immutable
class ListReviseProject extends StatelessWidget {
  ListReviseProject(
      {Key key,
      this.title,
      this.detail,
      this.jumlahTask,
      this.image,
      this.tag,
      this.onTapStar})
      : super(key: key);

  final String title, detail;
  final int jumlahTask;
  final String image;
  final bool tag;
  final Function onTapStar;
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
                    color: colorNeutral1.withOpacity(1),
                    blurRadius: 15,
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        child: Container(
                          width: 30,
                          height: 30,
                          child: Icon(
                            tag ? Icons.star : Icons.star_border,
                            color: colorPrimary,
                          ),
                        ),
                        onTap: onTapStar),
                    SizedBox(width: 10),
                    AvatarMedium(
                        imgUrl: "https://api-zukses.yokesen.com/$image"),
                    SizedBox(width: 10),
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
                          height: 5,
                        ),
                        Text(
                          detail,
                          style: TextStyle(fontSize: 12, color: colorPrimary50),
                        ),
                        SizedBox(
                          height: 2,
                        )
                      ],
                    )
                  ],
                ),
                jumlahTask < 1
                    ? Container()
                    : Container(
                        width: 20,
                        height: 20,
                        //padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: colorError, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            jumlahTask.toString(),
                            style: TextStyle(
                                color: colorBackground,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
              ],
            )));
  }
}
