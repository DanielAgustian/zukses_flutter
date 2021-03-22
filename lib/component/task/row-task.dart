import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TaskRow extends StatelessWidget {
  const TaskRow({
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
                child: SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: fontSize,
                          color: colorPrimary,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}