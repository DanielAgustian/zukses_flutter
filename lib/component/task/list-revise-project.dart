import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListReviseProject extends StatelessWidget {
  ListReviseProject(
      {Key key, this.title, this.detail, this.jumlahTask, this.image})
      : super(key: key);

  final String title, detail;
  final int jumlahTask;
  final String image;
  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    bool tag = true;
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
                        child: Icon(
                          tag ? Icons.star_border : Icons.star,
                          color: colorPrimary,
                        ),
                      ),
                      onTap: () {
                        tag = !tag;
                      },
                    ),
                    SizedBox(width: 10),
                    Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://api-zukses.yokesen.com/" + image),
                          ),
                        )),
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
