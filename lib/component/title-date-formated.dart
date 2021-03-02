import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class TitleDayFormatted extends StatelessWidget {
  TitleDayFormatted({
    Key key,
    this.fontSize = 18,
    @required this.currentDate,
  }) : super(key: key);

  final double fontSize;
  final DateTime currentDate;
  DateFormat getDayName = DateFormat('EEEE');
  DateFormat getDayNumber = DateFormat('d');
  DateFormat getMonthName = DateFormat('MMMM');
  DateFormat getYearNumber = DateFormat('y');

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: '${getDayName.format(currentDate)}, ',
          style: TextStyle(color: colorPrimary, fontSize: fontSize),
          children: <TextSpan>[
            TextSpan(
              text: '${getDayNumber.format(currentDate)} ',
            ),
            TextSpan(
              text: '${getMonthName.format(currentDate)} ',
            ),
            TextSpan(
              text: '${getYearNumber.format(currentDate)} ',
            )
          ],
        ),
      ),
    );
  }
}
