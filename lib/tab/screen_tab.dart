import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';

import 'package:zukses_app_1/tab/screen_task.dart';
import 'package:zukses_app_1/tab/screen_home.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/tab/screen_meeting.dart';
import 'package:zukses_app_1/tab/screen_attendance.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
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
    getUserProfile();
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
    //Firebase Handler
    firebaseMessagingHandler();
  }

  void firebaseMessagingHandler() {
    //Handle Click Notif from Background
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        notificationChecker(message);
      }
    });
    // handle click notif from foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification ios = message.notification?.apple;
      if (notification != null && (android != null || ios != null)) {
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

  void getUserProfile() async {
    BlocProvider.of<UserDataBloc>(context).add(UserDataGettingEvent());
  }

  void notificationChecker(RemoteMessage message) {
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
    UserModel user;
    return BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
      if (state is UserDataStateSuccessLoad) {
        user = state.userModel;
        if (user != null) {
          if (user.companyID == null) {
            screenList.removeWhere((element) => element is AttendanceScreen);
          }
        }
      }

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
                  color:
                      _currentScreenIndex == 0 ? colorPrimary : colorPrimary70,
                ),
                label: 'tab_text1'.tr(),
              ),
              if (user != null)
                if (user.companyID != null)
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/images/attendance-icon.svg',
                      color: _currentScreenIndex == 1
                          ? colorPrimary
                          : colorPrimary70,
                    ),
                    label: 'tab_text2'.tr(),
                  ),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.clipboardList),
                  label: 'tab_text3'.tr()),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.solidCalendar),
                  label: 'tab_text4'.tr()),
            ],
            unselectedFontSize: 12,
            selectedFontSize: 12,
            showUnselectedLabels: true,
            selectedItemColor: Color.fromRGBO(20, 43, 111, 0.9),
            unselectedItemColor: colorPrimary70,
            selectedIconTheme: IconThemeData(color: colorPrimary),
            unselectedIconTheme: IconThemeData(color: colorPrimary70),
          ));
    });
  }
}
