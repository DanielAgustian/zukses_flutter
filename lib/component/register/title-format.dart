import 'package:flutter/material.dart';

class TitleFormat extends StatelessWidget {
  const TitleFormat({Key key, this.title, this.detail, @required this.size})
      : super(key: key);

  final String title, detail;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: size.height < 569 ? 26 : 30,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        detail != ""
            ? Text(
                detail,
                style: TextStyle(
                    fontSize: size.height < 569 ? 12 : 16,
                    fontWeight: FontWeight.w300),
              )
            : Container(),
        detail != ""
            ? SizedBox(
                height: size.height < 569 ? 10 : 15,
              )
            : Container(),
      ],
    );
  }
}

class TitleFormatCenter extends StatelessWidget {
  const TitleFormatCenter(
      {Key key, this.title, this.detail, @required this.size})
      : super(key: key);

  final String title, detail;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: size.height < 569 ? 26 : 30,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        detail != ""
            ? Text(
                detail,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.height < 569 ? 12 : 16,
                    fontWeight: FontWeight.w300),
              )
            : Container(),
        detail != ""
            ? SizedBox(
                height: size.height < 569 ? 10 : 15,
              )
            : Container(),
      ],
    );
  }
}
