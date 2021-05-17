import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class TextFormat1 extends StatelessWidget {
  TextFormat1({
    Key key,
    this.title,
    this.data,
    this.txtColor = colorPrimary,
    @required this.size,
  }) : super(key: key);

  final String title, data;
  final Color txtColor;
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
            color: txtColor,
            fontSize: size.height < 569 ? 12 : 14,
          ),
        ),
      ],
    );
  }
}

class TextFormatEdit extends StatelessWidget {
  TextFormatEdit(
      {Key key,
      this.title,
      @required this.size,
      @required this.textEdit,
      this.onChanged})
      : super(key: key);

  final String title;
  final TextEditingController textEdit;
  final Size size;
  final Function onChanged;
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
        Container(
          decoration: BoxDecoration(
              color: colorNeutral130,
              border: Border.all(color: colorNeutral2),
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                isDense: true,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
            style:
                TextStyle(height: 1.2, fontSize: size.height < 569 ? 14 : 16),
            controller: textEdit,
            onChanged: (val) {
              onChanged(val);
            },
          ),
        )
      ],
    );
  }
}
