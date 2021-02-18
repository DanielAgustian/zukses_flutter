import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/listViewBox.dart';
import 'package:zukses_app_1/component/listviewboxmeeting.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/punch-system/camera-instruction.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
                        textStyle:
                            TextStyle(color: Colors.white, letterSpacing: 1.5),
                        fontSize: 14,
                      ),
                    ),
                  ]))),
        ),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Hi, Finley Khouwira",
                  style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(color: colorPrimary, letterSpacing: 0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "WELCOME BACK! ",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Colors.grey, letterSpacing: 0),
                        fontSize: 12,
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
        Padding(
          padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Task List",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: colorNeutral2.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "8",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(240, 87, 105, 0.9),
                                    letterSpacing: 0),
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "High Priority Task",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: colorPrimary, letterSpacing: 0),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: colorNeutral2.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            "8",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(27, 181, 92, 0.9),
                                    letterSpacing: 0),
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Low Priority Task",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: colorPrimary, letterSpacing: 0),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                )
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
                tasktitle: taskName[index],
                taskdetail: taskDetail[index],
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "2",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(240, 87, 105, 0.9),
                                    letterSpacing: 0),
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Meeting Schedule",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: colorPrimary, letterSpacing: 0),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ]),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "11",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(255, 214, 2, 1),
                                    letterSpacing: 0),
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Meeting Request",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: colorPrimary, letterSpacing: 0),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                )
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
              return ListViewBoxMeeting(
                meetingtitle: meetName[index],
                meetingdetail: meetTime[index],
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    )));
  }

//------------------------------BackEnd----------------------------//
  void tapHour() {
    if (stringTap == "Clock in") {
      stringTap = "Clock Out";
    } else {
      stringTap = "Locked";
    }
  }
}
