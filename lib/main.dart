import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/employee/employee-bloc.dart';
import 'package:zukses_app_1/bloc/leave-type/leave-type-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';

import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/repository/auth-repo.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/onboarding/onboarding-card.dart';
import 'package:zukses_app_1/component/onboarding/dots-indicator.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

import 'bloc/leaves/leave-bloc.dart';
import 'bloc/overtime/overtime-bloc.dart';
import 'bloc/team/team-bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocObserver();
  // await Firebase.initializeApp();

  // check is user have been login
  String token;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token");

  runApp(
      //DevicePreview(
      //builder: (context) =>
      MyApp(
    token: token,
  )
      // )
      );
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
      ],
      child: MaterialApp(
        title: 'Zukses: Application for Office',
        theme: ThemeData(
            scaffoldBackgroundColor: colorBackground,
            fontFamily: 'Lato',
            accentColor: colorPrimary),
        // locale: DevicePreview.locale(context), // Add the locale here
        // builder: DevicePreview.appBuilder, // Add the builder here
        home: token != null
            ? ScreenTab()
            : MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
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
    // print(date.weekday);
    // print(dayName.format(date));
    // print(findFirstDateOfTheWeek(date));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "ZUKSES",
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: colorPrimary, letterSpacing: 1.5),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Container(
                      width: size.width,
                      height: size.height * 0.65,
                      child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (value) {
                          setState(() {
                            currentIdx = value;
                          });
                        },
                        itemBuilder: (context, position) {
                          return OnBoardingCard(
                            size: size,
                            title: "LOREM IPSUM",
                            description:
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
                            image: Image.asset(
                              "assets/images/onboarding.png",
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                        itemCount: 3, // Can be null
                      )),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(20.0),
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
                            width: size.height < 600 ? 40 : 60,
                            height: size.height < 600 ? 40 : 60,
                            child: Icon(Icons.arrow_forward,
                                size: 35.0, color: Colors.white70),
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        )
                      : Column(
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
                            SizedBox(height: 10),
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
                        )
                ]))));
  }
}
