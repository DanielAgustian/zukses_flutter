import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
  ScreenTab({Key key, this.title, this.index, this.link}) : super(key: key);
  final String title;
  final int index;
  final Uri link;
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

    screenList.add(TaskScreen());
    screenList.add(MeetingScreen());
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
    // push to user screen if [new follower]
    else if (message.notification.title
        .toLowerCase()
        .contains("new follower")) {}
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
            icon: ImageIcon(AssetImage('assets/images/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/attendance-icon.png')),
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
