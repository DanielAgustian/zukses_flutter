import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ThirdPage createState() => _ThirdPage();
}

class _ThirdPage extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Zukses"),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "ZUKSES",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(20, 43, 111, 0.9),
                        letterSpacing: 1.5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(20, 43, 111, 0.9),
                    shape: BoxShape.circle),
              ),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 1, 40, 0),
                      child: Text(
                        "Lorem Pisum",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(135, 147, 181, 0.9))),
                      ))),
              Padding(
                  padding: EdgeInsets.fromLTRB(40, 1, 40, 0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ',
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(20, 43, 111, 0.9))),
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Color.fromRGBO(128, 128, 128, 0.9),
                  width: 7.0,
                  height: 7.0,
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Color.fromRGBO(128, 128, 128, 0.9),
                  width: 7.0,
                  height: 7.0,
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Color.fromRGBO(20, 43, 111, 0.9),
                  width: 10.0,
                  height: 10.0,
                ),
              ]),
              SizedBox(height: 15),
              SizedBox(
                width: 250,
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Color.fromRGBO(20, 43, 111, 0.9),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenSignUp()),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: new Text(
                    "Sign Up",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Color.fromRGBO(20, 43, 111, 0.9),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenLogin()),
                    );
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: Color.fromRGBO(20, 43, 111, 0.9), width: 2)),
                  child: new Text(
                    "Log In",
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
              )
            ])));
  }
}
