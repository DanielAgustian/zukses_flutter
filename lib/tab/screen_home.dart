import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/home/box-home.dart';
import 'package:zukses_app_1/component/home/listviewbox.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/punch-system/camera-instruction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _HomeScreenState extends State<HomeScreen> {
  String stringTap = "Clock In";
  var taskName = ["Task 1", "task 2"];
  var taskDetail = ["Task 1", "task 2"];
  var meetName = ["Meeting 1", "Meeting 2"];
  var meetTime = ["14:00-15:00", "19:00-20:00"];
  @override
  void initState() {
    super.initState();
  }

  void sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool clockIn = prefs.getBool("Clock In");
    if (clockIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PopUp()),
      );
    } else {
      print("Not Clock In Yet");
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new GestureDetector(
            onTap: () {
              print("Container clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraInstruction()),
              );
              //tapHour();
            },
            child: new Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40)),
                  color: colorPrimary,
                ),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        "14.00",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white, letterSpacing: 1.5),
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Tap Here to " + stringTap,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white, letterSpacing: 1.5),
                          fontSize: 14,
                        ),
                      ),
                    ]))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Finley Khouwira",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: colorPrimary, letterSpacing: 0),
                              fontSize: size.width <= 569 ? 16 : 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "WELCOME BACK! ",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.grey, letterSpacing: 0),
                                fontSize: size.width <= 569 ? 10 : 12,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(20, 43, 111, 0.9),
                                  shape: BoxShape.circle))
                        ],
                      ))
                ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Task List",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                    fontSize: size.width <= 569 ? 18 : 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoxHome(
                    title: "High Priority Task",
                    total: 8,
                    numberColor: colorSecondaryRed,
                    fontSize: size.width <= 569 ? 34 : 36,
                  ),
                  BoxHome(
                      title: "Low Priority Task",
                      total: 8,
                      numberColor: colorClear,
                      fontSize: size.width <= 569 ? 34 : 36),
                ],
              )),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: colorNeutral150,
                blurRadius: 5,
              )
            ]),
            child: ListView.builder(
              itemCount: taskName.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListViewBox(
                  title: taskName[index],
                  detail: taskDetail[index],
                  viewType: "task",
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Meeting List",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                    fontSize: size.width <= 569 ? 18 : 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BoxHome(
                      title: "Meeting Schedule",
                      total: 3,
                      numberColor: colorSecondaryRed,
                      fontSize: size.width <= 569 ? 34 : 36),
                  BoxHome(
                      title: "Meeting Request",
                      total: 11,
                      numberColor: colorSecondaryYellow,
                      fontSize: size.width <= 569 ? 34 : 36),
                ],
              )),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: colorNeutral2.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
            child: ListView.builder(
              itemCount: taskName.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListViewBox(
                  title: meetName[index],
                  detail: meetTime[index],
                  viewType: "meeting",
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context));
      }),
    );
  }

//------------------------------BackEnd----------------------------//
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/dummy.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Clock Out Success!",
            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: colorPrimary,
              child: Text(
                "OK!",
                style: TextStyle(color: colorBackground),
              ))
        ],
      ),
      actions: <Widget>[
        /*
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),*/
      ],
    );
  }

  void tapHour() {
    if (stringTap == "Clock in") {
      stringTap = "Clock Out";
    } else {
      stringTap = "Locked";
    }
  }
}

class PopUp extends StatelessWidget {
  const PopUp({
    Key key,
  }) : super(key: key);
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/dummy.png",
            height: 200,
            width: 200,
          ),
          Text(
            "Clock Out Success!",
            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: colorPrimary,
              child: Text(
                "OK!",
                style: TextStyle(color: colorBackground),
              ))
        ],
      ),
      actions: <Widget>[
        /*
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),*/
      ],
    );
  }
}
