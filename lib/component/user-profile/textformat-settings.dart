import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TextFormatSettings extends StatelessWidget {
  const TextFormatSettings(
      {this.title,
      this.detail,
      this.onClick,
      this.size,
      this.index,
      this.isSwitched});
  final String title, detail;
  final int index;
  final Function onClick;
  final Size size;
  final bool isSwitched;
  @override
  Widget build(BuildContext context) {
    bool switchTemp = isSwitched;
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: colorNeutral2)),
            color: colorBackground),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: colorPrimary, fontSize: size.height < 570 ? 14 : 16),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: colorPrimary,
              ),
            ),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                onClick;
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormatSettings2 extends StatelessWidget {
  const TextFormatSettings2(
      {this.title,
      this.detail,
      this.onClick,
      this.size,
      this.index,
      this.status});
  final String title, detail;
  final int index;
  final Function onClick;
  final Size size;
  final bool status;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: colorBackground,
            border: Border(bottom: BorderSide(width: 1, color: colorNeutral2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: size.height < 570 ? 14 : 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  detail,
                  style: TextStyle(
                      color: colorNeutral3,
                      fontSize: size.height < 570 ? 12 : 14),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: colorPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
