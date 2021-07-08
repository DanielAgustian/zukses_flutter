import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class ContactSPVBox extends StatelessWidget {
  ContactSPVBox(
      {this.title,
      this.date,
      this.size,
      this.onClick,
      this.onDelete,
      this.linkPicture,
      this.detail});
  final Size size;
  final String title;
  final DateTime date;
  final Function onClick, onDelete;
  final String linkPicture;
  final String detail;
  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          padding: EdgeInsets.symmetric(horizontal: 8),
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorBackground,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)
              ]),
          child: InkWell(
            onTap: onClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                linkPicture != null
                    ? Container(
                        height: 0.15 * size.width - 10,
                        width: 0.15 * size.width - 10,
                        margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://api-zukses.yokesen.com/" +
                                        linkPicture),
                                fit: BoxFit.fill),
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : Container(
                        height: 0.15 * size.width - 5,
                        width: 0.15 * size.width - 5,
                        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(right: 3),
                            height: 0.07 * size.width,
                            width: 0.07 * size.width,
                            child: SvgPicture.asset(
                              "assets/images/photo-placeholder.svg",
                            ),
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 0.48 * size.width - 5,
                      child: Column(
                        children: [
                          Column(
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
                                height: 5,
                              ),
                              Text(
                                detail,
                                style: TextStyle(
                                  color: colorNeutral3,
                                  fontSize: size.height < 569 ? 12 : 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 0.3 * size.width - 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 13,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              Util().dateNumbertoCalendar(date),
                              style: TextStyle(
                                  fontSize: size.height < 569 ? 12 : 14,
                                  color: colorNeutral3),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              Util().dateTimeToTimeOfDay(date),
                              style: TextStyle(
                                  fontSize: size.height < 569 ? 12 : 14,
                                  color: colorNeutral3),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        secondaryActions: [
          IconSlideAction(
              iconWidget: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: colorError),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.white,
                  ),
                ),
              ),
              color: colorBackground,
              onTap: () {
                print("Delete");
                showDialog(
                    context: context,
                    builder: (context) =>
                        _buildPopupClockOut(context, size: size));
              }),
        ]);
  }

  Widget _buildPopupClockOut(BuildContext context, {size}) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Are you sure to delete this schedule ?",
            style: TextStyle(
                color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          LongButton(
              size: size,
              bgColor: colorPrimary,
              textColor: colorBackground,
              title: "Yes ",
              onClick: onDelete),
          SizedBox(
            height: 10,
          ),
          LongButtonOutline(
            size: size,
            bgColor: colorBackground,
            textColor: colorPrimary,
            outlineColor: colorPrimary,
            title: "No",
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
