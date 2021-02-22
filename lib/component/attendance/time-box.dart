import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/dummy-model.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({
    Key key,
    @required this.selected,
    this.space = 25,
    this.fontSize = 20,
  }) : super(key: key);

  final AbsenceTime selected;
  final double space;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: colorPrimary, width: 2)),
            child: Text(
              selected == null ? "--.--" : "${selected.time1}",
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize),
            ),
          ),
          SizedBox(width: space),
          FaIcon(
            FontAwesomeIcons.arrowRight,
            color: colorPrimary,
            size: fontSize,
          ),
          SizedBox(width: space),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: colorPrimary, width: 2)),
            child: Text(
              selected == null ? "--.--" : "${selected.time2}",
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
