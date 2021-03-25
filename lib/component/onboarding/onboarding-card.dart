import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/constant/constant.dart';

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard({
    Key key,
    this.title,
    this.description,
    this.image,
    this.size,
  }) : super(key: key);

  final String title, description;
  final Widget image;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                color: Color.fromRGBO(240, 239, 242, 1),
                blurRadius: 15),
          ],
          color: colorBackground),
      child: Column(
        children: [
          SizedBox(height: 30),
          CircleAvatar(
              backgroundColor: colorBackground,
              radius: size.height < 600 ? size.width * 0.15 : size.width * 0.25,
              child: image),
          SizedBox(height: 40),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 1, 40, 0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: size.height < 600 ? 14 : 16,
                        color: Color.fromRGBO(135, 147, 181, 0.9))),
              )),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 1, 40, 0),
            child: Text(description,
                style: TextStyle(
                    fontSize: size.height < 600 ? 12 : 14,
                    color: Color.fromRGBO(20, 43, 111, 0.9))),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
