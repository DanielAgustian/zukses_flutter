import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class ListViewBox extends StatelessWidget {
  ListViewBox({
    Key key,
    this.title,
    this.detail,
    this.viewType,
    this.widget1,
    this.widget2,
    this.loading = true,
    this.skeletonSize = 200,
  }) : super(key: key);

  final String title, detail, viewType;
  final Widget widget1, widget2;
  final bool loading;
  final double skeletonSize;

  DateFormat dateFormat = DateFormat.yMMMMd();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            decoration: BoxDecoration(
              color: colorBackground,
              border: Border(
                bottom: BorderSide(width: 1.0, color: colorNeutral2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loading
                    ? Column(
                        children: [
                          SkeletonAnimation(
                            shimmerColor: colorNeutral170,
                            child: Container(
                              color: colorNeutral2,
                              width: skeletonSize,
                              height: 8,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SkeletonAnimation(
                            shimmerColor: colorNeutral170,
                            child: Container(
                              color: colorNeutral2,
                              width: skeletonSize,
                              height: 8,
                            ),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style:
                                  TextStyle(fontSize: 14, color: colorPrimary),
                            ),
                          ),
                          Text(
                            detail,
                            style:
                                TextStyle(fontSize: 12, color: colorNeutral2),
                          )
                        ],
                      ),
                viewType == "meeting"
                    ? Container()
                    : loading
                        ? Row(
                            children: [
                              SkeletonAnimation(
                                shimmerColor: colorNeutral170,
                                child: Container(
                                  color: colorNeutral2,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              SkeletonAnimation(
                                shimmerColor: colorNeutral170,
                                child: Container(
                                  color: colorNeutral2,
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FaIcon(FontAwesomeIcons.tasks,
                                  color: colorSecondaryYellow),
                              SizedBox(width: 20),
                              FaIcon(
                                FontAwesomeIcons.tasks,
                                color: colorSecondaryRed,
                              )
                            ],
                          )
              ],
            )));
  }
}
