import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/module/calendar-widget.dart';

class MeetingScreen extends StatefulWidget {
  MeetingScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.5,
              child: CalendarWidget(),
            ),
            Center(
              child: Text('This is Tab Meeting'),
            ),
          ],
        ),
      )),
    );
  }
}
