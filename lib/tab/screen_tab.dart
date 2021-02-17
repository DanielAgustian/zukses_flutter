import 'package:flutter/material.dart';
import 'package:zukses_app_1/tab/screen_home.dart';
import 'package:zukses_app_1/tab/screen_meeting.dart';
import 'package:zukses_app_1/tab/screen_task.dart';
import 'package:zukses_app_1/tab/screen_attendance.dart';

class ScreenTab extends StatefulWidget {
  ScreenTab({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ScreenTab createState() => _ScreenTab();
}

class _ScreenTab extends State<ScreenTab> {
  List<Widget> screenList = [];
  int _currentScreenIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentScreenIndex = 0;
    screenList.add(HomeScreen());
    screenList.add(AttendanceScreen());
    screenList.add(TaskScreen());
    screenList.add(MeetingScreen());
  }

  void onTabTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zukses'),
      ),
      body: screenList[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex:
            _currentScreenIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.check),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel_outlined), label: 'Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Schedule'),
        ],
        unselectedFontSize: 12,
        selectedFontSize: 14,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromRGBO(20, 43, 111, 0.9),
        unselectedItemColor: Colors.grey,
        selectedIconTheme:
            IconThemeData(color: Color.fromRGBO(20, 43, 111, 0.9)),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
      ),
    );
  }
}
