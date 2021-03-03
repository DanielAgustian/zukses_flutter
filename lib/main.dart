import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/third_click.dart';
import 'package:zukses_app_1/second_click.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_preview/device_preview.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/onboarding/onboarding-card.dart';
import 'package:zukses_app_1/component/onboarding/dots-indicator.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zukses: Application for Office',
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // Add the builder here
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  DateTime date = DateTime.now();
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
                      height: size.height * 0.6 + 10,
                      child: PageView.builder(
                        controller: _controller,
                        itemBuilder: (context, position) {
                          return OnBoardingCard(
                            size: size,
                            title: "LOREM IPSUM",
                            description:
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
                            image: Image.asset("assets/images/ava.png"),
                          );
                        },
                        itemCount: 3, // Can be null
                      )),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Container(
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.all(20.0),
                          child: new Center(
                            child: new DotsIndicator(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ThirdPage()),
                            );
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
                  SizedBox(height: 30),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondPage()),
                      );
                    },
                    elevation: 2.0,
                    fillColor: Color.fromRGBO(20, 43, 111, 0.9),
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.arrow_forward,
                          size: 35.0, color: Colors.white70),
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ]))));
  }
}
