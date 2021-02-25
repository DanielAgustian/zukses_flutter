import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({
    Key key,
    @required this.size,
    this.title,
    this.time1,
    this.time2, this.onClick,
  }) : super(key: key);

  final Size size;
  final String title;
  final String time1, time2;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorBackground,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 0), color: colorNeutral150, blurRadius: 15),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                  color: colorPrimary,
                )),
            SizedBox(
              height: 5,
            ),
            Text('$time1 - $time2',
                style: TextStyle(
                  fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                  color: colorPrimary50,
                )),
            SizedBox(
              height: 5,
            ),
            Container(
                height: 20,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return UserAvatar();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
