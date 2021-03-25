import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/attendance-model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({
    Key key,
    @required this.selected,
    this.space = 25,
    this.fontSize = 20,
  }) : super(key: key);

  final AttendanceModel selected;
  final double space;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    String h1 = " - - ";
    String h2 = " - - ";
    String m1 = " - - ";
    String m2 = " - - ";
    // formating time
    if (selected != null) {
      if (selected.clockIn != null) {
        //formating time 1
        selected.clockIn.hour >= 10
            ? h1 = "${selected.clockIn.hour}"
            : h1 = "0${selected.clockIn.hour}";
        selected.clockIn.minute >= 10
            ? m1 = "${selected.clockIn.minute}"
            : m1 = "0${selected.clockIn.minute}";
      }

      if (selected.clockOut != null) {
        //formating time 1
        selected.clockOut.hour >= 10
            ? h2 = "${selected.clockOut.hour}"
            : h2 = "0${selected.clockOut.hour}";
        selected.clockOut.minute >= 10
            ? m2 = "${selected.clockOut.minute}"
            : m2 = "0${selected.clockOut.minute}";
      }
    }
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
              "$h1.$m1",
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
              "$h2.$m2",
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

class OvertimeText extends StatelessWidget {
  const OvertimeText({
    Key key,
    @required this.selected,
    @required this.size,
    this.space = 25,
    this.fontSize = 20,
  }) : super(key: key);
  final AttendanceModel selected;
  final int space, fontSize;
  final Size size;
  @override
  Widget build(BuildContext context) {
    String overtime = "";
    if (selected != null) {
      if (selected.overtime != null) {
        overtime = selected.overtime;
      }
    }
    return Container(
        child: Text(
      overtime == "" ? "Overtime : 0 Hrs" : "Overtime : " + overtime
      /*selected.overtime.substring(0, 2) +
              " hours " +
              selected.overtime.substring(3, 5) +
              " minutes"*/
      ,
      style: TextStyle(
          color: colorPrimary,
          fontSize: size.width <= 569 ? textSizeSmall18 : 18),
    ));
  }
}
