import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddScheduleRow extends StatelessWidget {
  const AddScheduleRow({
    Key key,
    this.title,
    this.textItem,
    this.fontSize: 16,
  }) : super(key: key);

  final String title, textItem;
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
                      color: colorPrimary,
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}

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
