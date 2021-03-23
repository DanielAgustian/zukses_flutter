import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TextFormat1 extends StatelessWidget {
  TextFormat1({
    Key key,
    this.title,
    this.data,
    @required this.size,
  }) : super(key: key);

  final String title, data;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        Text(
          title,
          style: TextStyle(
              color: colorPrimary,
              fontSize: size.height < 569 ? 14 : 16,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height < 569 ? 5 : 10,
        ),
        Text(
          data,
          style: TextStyle(
            color: colorPrimary,
            fontSize: size.height < 569 ? 12 : 14,
          ),
        ),
      ],
    );
  }
}
