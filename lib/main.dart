import 'dart:async';
//import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/change-task-bloc/change-task-bloc.dart';
import 'package:zukses_app_1/bloc/checklist-task-put/checklist-task-put-bloc.dart';
import 'package:zukses_app_1/bloc/checklist-task/checklist-task-bloc.dart';
import 'package:zukses_app_1/bloc/comment/comment-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/employee/employee-bloc.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-bloc.dart';
import 'package:zukses_app_1/bloc/label-task/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-search/meeting-search-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/payment/payment-bloc.dart';
import 'package:zukses_app_1/bloc/pricing/pricing-bloc.dart';
import 'package:zukses_app_1/bloc/project-bookmark/project-bookmark-bloc.dart';
import 'package:zukses_app_1/bloc/project/project-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-bloc.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-bloc.dart';
import 'package:zukses_app_1/bloc/upload-attachment/upload-attachment-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';

import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/onboarding/onboarding-card.dart';
import 'package:zukses_app_1/component/onboarding/dots-indicator.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/test_ios.dart';
import 'package:zukses_app_1/util/util.dart';

import 'bloc/leaves/leave-bloc.dart';
import 'bloc/overtime/overtime-bloc.dart';
import 'bloc/task/task-bloc.dart';
import 'bloc/team/team-bloc.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

IOSInitializationSettings initializationSettingsIOs =
    IOSInitializationSettings();

InitializationSettings initSetttings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = BlocObserver();
  await Firebase.initializeApp();

  // check is user have been login
  String token;
  bool onboarding;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");
  onboarding = prefs.getBool("onboarding");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  /*AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/traderindo_logo');*/

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('id')],
    path: "assets/lang",
    fallbackLocale: Locale('id'),
    child: MyApp(
      token: token,
      onboarding: onboarding,
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String token;
  final bool onboarding;
  const MyApp({Key key, this.token, this.onboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(authRepo: AuthenticationRepository()),
        ),
        BlocProvider<AttendanceBloc>(
          create: (context) => AttendanceBloc(),
        ),
        BlocProvider<UserDataBloc>(
          create: (context) => UserDataBloc(),
        ),
        BlocProvider<EmployeeBloc>(
          create: (context) => EmployeeBloc(),
        ),
        BlocProvider<MeetingBloc>(
          create: (context) => MeetingBloc(),
        ),
        BlocProvider<LeaveTypeBloc>(
          create: (context) => LeaveTypeBloc(),
        ),
        BlocProvider<LeaveBloc>(
          create: (context) => LeaveBloc(),
        ),
        BlocProvider<OvertimeBloc>(
          create: (context) => OvertimeBloc(),
        ),
        BlocProvider<TeamBloc>(
          create: (context) => TeamBloc(),
        ),
        BlocProvider<CompanyBloc>(
          create: (context) => CompanyBloc(),
        ),
        BlocProvider<MeetingReqBloc>(
          create: (context) => MeetingReqBloc(),
        ),
        BlocProvider<BussinessScopeBloc>(
          create: (context) => BussinessScopeBloc(),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(),
        ),
        BlocProvider<PaymentBloc>(create: (context) => PaymentBloc()),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
        BlocProvider<PricingBloc>(create: (context) => PricingBloc()),
        BlocProvider<TeamDetailBloc>(create: (context) => TeamDetailBloc()),
        BlocProvider<ProjectBloc>(create: (context) => ProjectBloc()),
        BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
        BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
        BlocProvider<LabelTaskBloc>(create: (context) => LabelTaskBloc()),
        BlocProvider<CLTBloc>(create: (context) => CLTBloc()),
        BlocProvider<CLTPBloc>(create: (context) => CLTPBloc()),
        BlocProvider<ChangeTaskBloc>(create: (context) => ChangeTaskBloc()),
        BlocProvider<UploadAttachBloc>(create: (context) => UploadAttachBloc()),
        BlocProvider<TaskPriorityBloc>(create: (context) => TaskPriorityBloc()),
        BlocProvider<MeetingSearchBloc>(
          create: (context) => MeetingSearchBloc(),
        ),
        BlocProvider<ProjectBookmarkBloc>(
          create: (context) => ProjectBookmarkBloc(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: EasyLocalization.of(context).locale,
        routes: <String, WidgetBuilder>{
          '/LoginScreen': (BuildContext context) => new ScreenLogin()
        },
        title: 'Zukses: Application for Office',
        theme: ThemeData(
            scaffoldBackgroundColor: colorBackground,
            fontFamily: 'Lato',
            accentColor: colorPrimary),
        //locale: DevicePreview.locale(context), // Add the locale here
        //builder: DevicePreview.appBuilder, // Add the builder here
        home: SplashScreen(
          token: token,
          onboarding: onboarding,
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title, this.token, this.onboarding})
      : super(key: key);
  final String title, token;
  final bool onboarding;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "v1.0 Beta";
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _loadWidget();
    reqPermission();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  NotificationSettings setting;

  void reqPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    setState(() {
      setting = settings;
    });

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void navigationPage() {
    if (widget.token != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => ScreenTab()));
      // MaterialPageRoute(builder: (BuildContext context) => TestNotifIOS()));
    } else {
      if (widget.onboarding == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ScreenLogin()));
        // builder: (BuildContext context) => TestNotifIOS()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorPrimaryGradient1,
              colorPrimaryGradient1,
              colorPrimaryGradient2,
              colorPrimaryGradient3,
              colorPrimaryGradient3,
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            "assets/images/zukses-logo.svg",
          ),
          CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ],
      ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.logOut}) : super(key: key);

  final String title;
  final String logOut;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var dayOfWeek = 1;
  int _currentPage = 0;

  String sprefToken = '';
  DateFormat dayName = DateFormat('E');
  Timer _timerLink;
  bool getDynamicLinkDone = false;
  PageController _controller;
  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  _stopOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboarding", true);
  }

  _loadWidget() async {
    var _duration = Duration(seconds: 0);
    return Timer(_duration, afterlogOut);
  }

  afterlogOut() {
    if (widget.logOut != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ScreenLogin()));
    }
  }

  int currentIdx = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: 0,
    );
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page.toInt();
      });
    });
    getToken();
    WidgetsBinding.instance.addObserver(this);
    //dynamicLink();
    _loadWidget();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          dynamicLink();
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  dynamicLink() async {
    Util().initDynamicLinks(context);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sprefToken = prefs.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        backgroundColor: colorBackground,
        body: Container(
            width: size.width,
            height: size.height * 0.86,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: size.width,
                      height: size.height * 0.55,
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (value) {
                          setState(() {
                            currentIdx = value;
                          });
                        },
                        itemBuilder: (context, position) {
                          return _printOnboardingCard(position, size);
                        },
                        itemCount: 3, // Can be null
                      )),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Center(
                            child: DotsIndicator(
                              color: colorPrimary,
                              controller: _controller,
                              itemCount: 3,
                              onPageSelected: (int page) {
                                _controller.animateToPage(
                                  page,
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      _currentPage > 1
                          ? Container(
                              height: 30,
                            )
                          : Container(
                              padding: EdgeInsets.only(top: 10),
                              height: 30,
                              margin: EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  _controller.animateToPage(2,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.linear);
                                },
                                child: Text(
                                  "SKIP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromRGBO(135, 147, 181, 0.9)),
                                ),
                              ),
                            )
                    ],
                  ),
                  SizedBox(height: 20),
                  currentIdx < 2
                      ? Container(
                          height: size.height < 569 ? 100 : 130,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (currentIdx != 2) {
                                _controller.animateToPage(currentIdx + 1,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.linear);
                              } else {
                                _controller.animateToPage(2,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.linear);
                              }
                            },
                            elevation: 2.0,
                            fillColor: Color.fromRGBO(20, 43, 111, 0.9),
                            child: Container(
                              width: size.height < 600 ? 40 : 55,
                              height: size.height < 600 ? 40 : 55,
                              child: Icon(Icons.arrow_forward,
                                  size: 35.0, color: Colors.white70),
                            ),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              LongButton(
                                  title: "Sign Up",
                                  textColor: colorBackground,
                                  bgColor: colorPrimary,
                                  onClick: () {
                                    _stopOnboarding();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScreenSignUp()),
                                    );
                                  },
                                  size: size),
                              SizedBox(height: size.height < 569 ? 5 : 10),
                              LongButtonOutline(
                                size: size,
                                title: "Log In",
                                bgColor: colorBackground,
                                textColor: colorPrimary,
                                onClick: () {
                                  _stopOnboarding();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScreenLogin()),
                                  );
                                },
                                outlineColor: colorPrimary,
                              ),
                              SizedBox(
                                height: size.height < 569 ? 5 : 10,
                              )
                            ],
                          ),
                        )
                ])));
  }

  //TO PRINT THE ONBOARDING CARD
  Widget _printOnboardingCard(int position, Size size) {
    if (position == 0) {
      return OnBoardingCard(
        size: size,
        title: "MEETING SCHEDULER",
        description:
            "Get your meeting scheduled neatly and notify all team members in just one click.",
        image: Image.asset(
          "assets/images/onboarding-0.png",
          fit: BoxFit.fill,
        ),
      );
    } else if (position == 1) {
      return OnBoardingCard(
        size: size,
        title: "TASK MANAGER",
        description:
            "Managing your task has never been easier. Planning and prioritizing can be done easily just by drag and drop. ",
        image: Image.asset(
          "assets/images/onboarding-1.png",
          fit: BoxFit.fill,
        ),
      );
    } else if (position == 2) {
      return OnBoardingCard(
        size: size,
        title: "ATTENDANCE MANAGER",
        description:
            "Leave all the long-winded method, clock in and clock out is all you need to do to record your attendance.",
        image: Image.asset(
          "assets/images/onboarding.png",
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container();
    }
  }
}
