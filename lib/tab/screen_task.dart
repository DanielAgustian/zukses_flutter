import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TaskScreen createState() => _TaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskScreen extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('This is Tab Task'),
    ));
  }
}
