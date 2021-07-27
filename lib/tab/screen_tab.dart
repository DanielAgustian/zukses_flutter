import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/bloc/notif-nav-bar/notif-nav-bloc.dart';
import 'package:zukses_app_1/bloc/notif-nav-bar/notif-nav-event.dart';
import 'package:zukses_app_1/bloc/notif-nav-bar/notif-nav-state.dart';
import 'package:zukses_app_1/model/fb_model_sender.dart';
import 'package:zukses_app_1/model/google-sign-in-model.dart';
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
      this.meetingId,
      this.gotoMeeting})
      : super(key: key);
  final String title;
  final int index;
  final Uri link;
  final String projectId;
  final bool gotoMeeting;
  final String meetingId;
  @override
  _ScreenTab createState() => _ScreenTab();
}

class _ScreenTab extends State<ScreenTab> {
  List<Widget> screenList = [];
  int _currentScreenIndex;
  int notifTask = 0, notifSchedule = 0;
  @override
  void initState() {
    super.initState();
    getUserProfile();

    //Function for Init Screen
    initializationScreen();

    Util util = Util();
    util.initDynamicLinks(context);

    //Firebase Handler
    firebaseMessagingHandler();

    // Init data user and pass it to home via bloc listener
    authenticateUser();

    //Function for get Notif badge.
    getNotifBadge();

    //Function for Loading Screen Home APIs
    screenHomeLoader();

    //Function for Loading Attendance SCreen API
  }

  Widget build(BuildContext context) {
    UserModel user;
    return BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
      if (state is UserDataStateSuccessLoad) {
        user = state.userModel;
        if (user != null) {
          if (user.companyID == null || user.companyID == "") {
            screenList.removeWhere((element) => element is AttendanceScreen);
          } else {
            if (screenList.length < 4) {
              screenList.insert(1, AttendanceScreen());
            }
          }
        }
      }
      return Stack(
        children: [
          BlocListener<NotifNavBloc, NotifNavState>(
            listener: (context, state) {
              if (state is NotifNavStateSuccess) {
                setState(() {
                  notifTask = state.model.taskUnfinished;
                  notifSchedule = state.model.meetingToday;
                });
              }
            },
            child: Container(),
          ),
          Scaffold(
              backgroundColor: colorBackground,
              body: screenList[_currentScreenIndex],
              bottomNavigationBar: bottomNavbar(user)),
        ],
      );
    });
  }

  //Nav bar for full version
  Widget bottomNavbar(UserModel user) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      currentIndex:
          _currentScreenIndex, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SvgPicture.asset(
              'assets/images/home-icon.svg',
              color: _currentScreenIndex == 0 ? colorPrimary : colorPrimary70,
            ),
          ),
          label: 'tab_text1'.tr(),
        ),
        if (user != null)
          if (user.companyID != null && user.companyID != "")
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: SvgPicture.asset(
                  'assets/images/attendance-icon.svg',
                  color:
                      _currentScreenIndex == 1 ? colorPrimary : colorPrimary70,
                ),
              ),
              label: 'tab_text2'.tr(),
            ),
        BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
                  child: FaIcon(FontAwesomeIcons.clipboardList),
                ),
                badgeNotification(count: notifTask)
              ],
            ),
            label: 'tab_text3'.tr()),
        BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
                  child: FaIcon(FontAwesomeIcons.solidCalendar),
                ),
                badgeNotification(count: notifSchedule)
              ],
            ),
            label: 'tab_text4'.tr()),
      ],
      unselectedFontSize: 12,
      selectedFontSize: 12,
      showUnselectedLabels: true,
      selectedItemColor: Color.fromRGBO(20, 43, 111, 0.9),
      unselectedItemColor: colorPrimary70,
      selectedIconTheme: IconThemeData(color: colorPrimary),
      unselectedIconTheme: IconThemeData(color: colorPrimary70),
    );
  }

  Widget badgeNotification({int count}) {
    if (count < 1) {
      return Positioned(right: 0, top: 0, child: Container());
    }
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: colorError,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text("$count",
            style: TextStyle(color: colorBackground, fontSize: 10)),
      ),
    );
  }

  void initializationScreen() {
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

    if (widget.index != null) {
      _currentScreenIndex = widget.index;
    } else {
      _currentScreenIndex = 0;
    }

    if (widget.gotoMeeting != null) {
      if (widget.gotoMeeting) {
        _currentScreenIndex = screenList.length - 2;
      }
    }
  }

  void firebaseMessagingHandler() {
    //Handle Click Notif from Background
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("Received notification from Background . . . !");
        // notificationChecker(message);
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
            // notificationChecker(message);

            print("Received notification on Foreground . . . !");
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

  void getNotifBadge() {
    BlocProvider.of<NotifNavBloc>(context).add(GetNotifNavEvent());
  }

  void getUserProfile() async {
    BlocProvider.of<UserDataBloc>(context).add(UserDataGettingEvent());
  }

  void authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var googleSign = prefs.getInt('google');
    var facebookSign = prefs.getInt('facebook');
    String tokenFCM = prefs.getString('fcmToken');

    if (googleSign != null) {
      getAuthGoogle(tokenFCM);
    } else if (facebookSign != null) {
      getAuthFacebook(tokenFCM);
    } else {
      getAuthData(tokenFCM);
    }
  }

  void getAuthData(String tokenFCM) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    // print("username " + username);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginManual(
        email: username, password: password, tokenFCM: tokenFCM));
  }

  void getAuthGoogle(String tokenFCM) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('google_data');
    GoogleSignInModel model = GoogleSignInModel.fromJson(jsonDecode(data));
    // print("Email from Google = " + model.email);
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventDetectGoogleSignIn(
            email: model.email,
            name: model.name,
            image: model.image,
            tokenGoogle: model.token,
            tokenFCM: tokenFCM));
  }

  void getAuthFacebook(String tokenFCM) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('facebook_data');

    String tokenFacebook = prefs.getString('facebook_token');
    FBModelSender model = FBModelSender.fromJson(jsonDecode(data));

    // print("Email from facebook = " + model.email);
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventDetectGoogleSignIn(
            email: model.email,
            name: model.name,
            image: model.url,
            tokenGoogle: tokenFacebook,
            tokenFCM: tokenFCM));
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

  //=================== Beginning API For Screen Home =========================//
  void screenHomeLoader() {
    getMember();
    getCompanyProfile();
    _getMeetingToday();
    _getMeetingRequest();
    _getTaskLowPriority();
    _getTaskHighPriority();
    _getNotifAll();
  }

  void getCompanyProfile() async {
    BlocProvider.of<CompanyBloc>(context).add(CompanyEventGetProfile());
  }

  void _getMeetingToday() async {
    DateTime now = DateTime.now();
    BlocProvider.of<MeetingBloc>(context)
        .add(GetAcceptedMeetingEvent(month: now.month, year: now.year));
  }

  void _getMeetingRequest() async {
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
  }

  void getMember() async {
    BlocProvider.of<TeamBloc>(context).add(LoadAllTeamEvent());
  }

  void _getTaskLowPriority() async {
    BlocProvider.of<TaskBloc>(context).add(LoadLowPriorityTaskEvent("low"));
  }

  void _getTaskHighPriority() async {
    BlocProvider.of<TaskPriorityBloc>(context)
        .add(LoadHighPriorityEvent("high"));
  }

  void _getNotifAll() async {
    BlocProvider.of<NotifAllBloc>(context).add(GetNotifForAllEvent());
  }
}
