import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TextSequentialVertical extends StatelessWidget {
  const TextSequentialVertical({
    Key key,
    @required this.size,
    this.textcolor,
    this.text1,
    this.text2,
  }) : super(key: key);

  final Size size;
  final Color textcolor;
  final String text1, text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start Time",
            style: TextStyle(
                color: colorPrimary70, fontSize: size.height <= 600 ? 12 : 14),
          ),
          Text(
            "08.23",
            style: TextStyle(
                color: colorPrimary, fontSize: size.height <= 600 ? 12 : 14),
          ),
        ],
      ),
    );
  }
}
