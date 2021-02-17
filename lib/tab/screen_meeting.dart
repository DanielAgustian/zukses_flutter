import 'package:flutter/material.dart';

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
    return Container(
        child: Center(
      child: Text('This is Tab Meeting'),
    ));
  }
}
