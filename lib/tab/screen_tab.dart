import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';

import 'package:zukses_app_1/tab/screen_task.dart';
import 'package:zukses_app_1/tab/screen_home.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/tab/screen_meeting.dart';
import 'package:zukses_app_1/tab/screen_attendance.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class ScreenTab extends StatefulWidget {
  ScreenTab(
      {Key key,
      this.title,
      this.index,
      this.link,
      this.projectId,
      this.meetingId})
      : super(key: key);
  final String title;
  final int index;
  final Uri link;
  final String projectId;
  final String meetingId;
  @override
  _ScreenTab createState() => _ScreenTab();
}

class _ScreenTab extends State<ScreenTab> {
  List<Widget> screenList = [];
  int _currentScreenIndex;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      _currentScreenIndex = widget.index;
    } else {
      _currentScreenIndex = 0;
    }

    screenList.add(HomeScreen());
    screenList.add(AttendanceScreen());
    if (widget.projectId != null) {
      screenList.add(TaskScreen(
        projectId: widget.projectId,
      ));
    } else {
      screenList.add(TaskScreen());
    }
    if (widget.meetingId != null) {
      screenList.add(MeetingScreen(
        meetingId: widget.meetingId,
      ));
    } else {
      screenList.add(MeetingScreen());
    }

    Util util = Util();
    util.initDynamicLinks(context);

    // Handle Click Notif from BackGround
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("MESSAGE ========================");
        print(message.data);
        notificationChecker(message);
      }
    });

    // handle click notif from foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print("MASUK ==========================================++>");
        // print(notification.body);
        flutterLocalNotificationsPlugin.initialize(
          initSetttings,
          onSelectNotification: (payload) {
            notificationChecker(message);
            return;
          },
        );
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                //icon: '@mipmap/traderindo_logo',
              ),
            ),
            payload: notification.body);
      }
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  void notificationChecker(RemoteMessage message) {
    print(message.notification.title);
    print(message.data);
    //push to request inbox schedule if it is a meeting invitation
    if (message.notification.title
        .toLowerCase()
        .contains("meeting invitation")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RequestInbox()));
    }
    // push to task screen if create task
    else if (message.notification.title
        .toLowerCase()
        .contains("task assignment")) {
      print("Masuk task assignment");
      print(message.data["projectId"]);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenTab(
                    index: 2,
                    projectId: message.data["projectId"],
                  )));
    } else if (message.notification.title
        .toLowerCase()
        .contains("meeting response")) {
      print(message.data);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenTab(
                    index: 3,
                    meetingId: message.data["meetingId"],
                  )));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: screenList[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex:
            _currentScreenIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/home-icon.svg',
              color: _currentScreenIndex == 0 ? colorPrimary : colorPrimary70,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/attendance-icon.svg',
              color: _currentScreenIndex == 1 ? colorPrimary : colorPrimary70,
            ),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList), label: 'Task'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidCalendar), label: 'Schedule'),
        ],
        unselectedFontSize: 12,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromRGBO(20, 43, 111, 0.9),
        unselectedItemColor: colorPrimary70,
        selectedIconTheme: IconThemeData(color: colorPrimary),
        unselectedIconTheme: IconThemeData(color: colorPrimary70),
      ),
    );
  }
}
