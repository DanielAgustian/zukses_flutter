import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';

import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/employee/employee-bloc.dart';
import 'package:zukses_app_1/bloc/forgot-password/forgot-password-bloc.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/payment-bloc/payment-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';
import 'package:zukses_app_1/screen/forgot-password/check-your-email.dart';
import 'package:zukses_app_1/screen/forgot-password/forgot-password.dart';
import 'package:zukses_app_1/screen/forgot-password/reset-password.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/onboarding/onboarding-card.dart';
import 'package:zukses_app_1/component/onboarding/dots-indicator.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

import 'bloc/leaves/leave-bloc.dart';
import 'bloc/overtime/overtime-bloc.dart';
import 'bloc/sent-invite-team/sent-invite-bloc.dart';
import 'bloc/team/team-bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocObserver();
  // await Firebase.initializeApp();

  // check is user have been login
  String token;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");

  runApp(DevicePreview(
      builder: (context) => MyApp(
            token: token,
          )));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final String token;

  const MyApp({Key key, this.token}) : super(key: key);

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
        BlocProvider<SentInviteBloc>(create: (context) => SentInviteBloc()),
      ],
      child: MaterialApp(
        routes: <String, WidgetBuilder>{
          '/LoginScreen': (BuildContext context) => new ScreenLogin()
        },
        title: 'Zukses: Application for Office',
        theme: ThemeData(
            scaffoldBackgroundColor: colorBackground,
            fontFamily: 'Lato',
            accentColor: colorPrimary),
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder, // Add the builder here
        home: SplashScreen(token: token),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title, this.token}) : super(key: key);
  final String title, token;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "v1.0 Beta";
  final splashDelay = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (widget.token != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => ScreenTab()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Center(
            child: Text(
          "ZUKSES",
          style: GoogleFonts.lato(
              textStyle: TextStyle(color: colorPrimary, letterSpacing: 2),
              fontSize: size.height < 569 ? 40 : 46,
              fontWeight: FontWeight.bold),
        )),
        Positioned(
            bottom: 0.2 * size.height,
            left: 0.45 * size.width,
            child: CircularProgressIndicator()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "from Yokesen Technology Ltd.",
              style: TextStyle(
                  color: colorPrimary, fontSize: size.height < 569 ? 16 : 18),
            ),
          ),
        )
      ],
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dayOfWeek = 1;

  var _linkMessage = "";
  DateFormat dayName = DateFormat('E');

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

  int currentIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(
      initialPage: 0,
    );
    initDynamicLinks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initDynamicLinks() async {
    print("INIT DYNAMIC LINK");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      print(deepLink.path);
      if (deepLink != null) {
        // ignore: unawaited_futures
        String email = deepLink.queryParameters['email'];
        if (deepLink.path.toLowerCase().contains("/forgotpassword")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPassword(email: email)));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      String email = deepLink.queryParameters['email'];
      if (deepLink.path.toLowerCase().contains("/forgotpassword")) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPassword(email: email)));
      }
    }
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
                      Container(
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
                                color: Color.fromRGBO(135, 147, 181, 0.9)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  currentIdx < 2
                      ? RawMaterialButton(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScreenLogin()),
                                  );
                                },
                                outlineColor: colorPrimary,
                              ),
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
        title: "LOREM IPSUM" + position.toString(),
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
        image: Image.asset(
          "assets/images/onboarding-0.png",
          fit: BoxFit.fill,
        ),
      );
    } else if (position == 1) {
      return OnBoardingCard(
        size: size,
        title: "LOREM IPSUM" + position.toString(),
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
        image: Image.asset(
          "assets/images/onboarding-1.png",
          fit: BoxFit.fill,
        ),
      );
    } else if (position == 2) {
      return OnBoardingCard(
        size: size,
        title: "LOREM IPSUM" + position.toString(),
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
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
