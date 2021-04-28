import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/model/leave-type-model.dart';

class AddScheduleRow extends StatelessWidget {
  const AddScheduleRow({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
    this.arrowRight,
  }) : super(key: key);

  final String title, textItem, arrowRight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          Row(
            children: [
              Text(
                textItem,
                style: TextStyle(
                    fontSize: fontSize,
                    color: colorPrimary,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 10,
              ),
              title != "Time"
                  ? FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: arrowRight != "false"
                          ? colorPrimary
                          : colorBackground,
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}

class AddScheduleRowStatus extends StatelessWidget {
  const AddScheduleRowStatus({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
    this.arrowRight,
  }) : super(key: key);

  final String title, textItem, arrowRight;
  final double fontSize;

  Widget _buildText(BuildContext context) {
    String textHasil = "";
    Color colorText;
    if (textItem == "pending") {
      textHasil = "Requested";
      colorText = colorSecondaryYellow;
    } else if (textItem == "approved") {
      textHasil = "Approval";
      colorText = colorClear;
    } else if (textItem == "rejected") {
      textHasil = "Rejected";
      colorText = colorError;
    }
    return Text(
      textHasil,
      style: TextStyle(
          color: colorText, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          _buildText(context)
        ],
      ),
    );
  }
}

class AddScheduleRowNonArrow extends StatelessWidget {
  const AddScheduleRowNonArrow({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
    this.arrowRight,
  }) : super(key: key);

  final String title, textItem, arrowRight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          Text(
            textItem,
            style: TextStyle(
                fontSize: fontSize,
                color: colorPrimary,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
/*class AddScheduleRowHour extends StatelessWidget {
  const AddScheduleRowHour(
      {Key key,
      this.title,
      this.textHour1,
      this.textHour2,
      this.fontSize: 16,
      this.onSelected1,
      this.onSelected2})
      : super(key: key);

  final String title, textHour1, textHour2;
  final double fontSize;
  final Function onSelected1, onSelected2;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          Row(
            children: [
              InkWell(
                onTap: onSelected1,
                child: Text(
                  textHour1,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: colorPrimary,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                "-",
                style: TextStyle(
                    fontSize: fontSize,
                    color: colorPrimary,
                    fontWeight: FontWeight.w700),
              ),
              InkWell(
                onTap: onSelected2,
                child: Text(textHour2,
                    style: TextStyle(
                        fontSize: fontSize,
                        color: colorPrimary,
                        fontWeight: FontWeight.w700)),
              )
            ],
          )
        ],
      ),
    );
  }
}*/

class AddScheduleRow2 extends StatelessWidget {
  const AddScheduleRow2({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: textItem,
              icon: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: colorPrimary,
              ),
              elevation: 16,
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize),
              underline: Container(),
              onChanged: (String newValue) {
                onSelectedItem(newValue);
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    width: 100,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          value,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class AddScheduleRow3 extends StatelessWidget {
  const AddScheduleRow3({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title, textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          DropdownButton(
            value: textItem,
            icon: FaIcon(
              FontAwesomeIcons.chevronRight,
              color: colorPrimary,
            ),
            elevation: 16,
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
            underline: Container(),
            onChanged: (String newValue) {
              onSelectedItem(newValue);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: colorPrimary,
                      fontWeight: FontWeight.w700),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class AddScheduleLeaveType extends StatelessWidget {
  const AddScheduleLeaveType({
    Key key,
    this.title,
    this.textItem,
    this.fontSize,
    this.onSelectedItem,
    this.items,
  }) : super(key: key);

  final String title;
  final LeaveTypeModel textItem;
  final double fontSize;
  final Function onSelectedItem;
  final List<LeaveTypeModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title",
            style: TextStyle(fontSize: fontSize, color: colorPrimary),
          ),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: textItem,
              icon: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: colorPrimary,
              ),
              elevation: 16,
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize),
              underline: Container(),
              onChanged: (newValue) {
                onSelectedItem(newValue);
              },
              items: items.map<DropdownMenuItem<LeaveTypeModel>>(
                  (LeaveTypeModel value) {
                return DropdownMenuItem<LeaveTypeModel>(
                  value: value,
                  child: SizedBox(
                    width: 100,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          value.typeName,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: fontSize,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
