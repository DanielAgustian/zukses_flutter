import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/second_click.dart';
import 'package:zukses_app_1/third_click.dart';
import 'package:zukses_app_1/component/onboarding/onboarding-card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'Lato'),
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
                  OnBoardingCard(
                    size: size,
                    title: "LOREM IPSUM",
                    description:
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ",
                    image: Image.asset("assets/images/ava.png"),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(20, 43, 111, 0.9),
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                width: 7.0,
                                height: 7.0,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(128, 128, 128, 0.9),
                                    shape: BoxShape.circle),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                width: 7.0,
                                height: 7.0,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(128, 128, 128, 0.9),
                                    shape: BoxShape.circle),
                              ),
                            ]),
                      ),
                      Container(
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
                      ),
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
                      width: 70,
                      height: 70,
                      child: Icon(Icons.arrow_forward,
                          size: 35.0, color: Colors.white70),
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
                ]))));
  }
}
