import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AttendanceScreen createState() => _AttendanceScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AttendanceScreen extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('This is Tab Attendance'),
    ));
  }
}
