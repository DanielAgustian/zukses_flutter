import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/home/box-home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/home/listviewbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/punch-system/camera-instruction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:zukses_app_1/punch-system/camera-clock-in.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textReasonOvertime = new TextEditingController();
  final picker = ImagePicker();
  String key = "clock in";
  String stringTap = "Click Here to Clock In";
  var taskName = ["Task 1", "task 2"];
  var taskDetail = ["Task 1", "task 2"];
  var meetName = ["Meeting 1", "Meeting 2"];
  var meetTime = ["14:00-15:00", "19:00-20:00"];
  int clockIn;
  String dialogText = "Clock In ";
  bool instruction = false;
  @override
  void initState() {
    super.initState();
    sharedPref();
    sharedPrefInstruction();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new InkWell(
            onTap: () {
              print("Container clicked");
              if (clockIn == 1) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupClockOut(context, size: size));
              } else {
                if (instruction == true) {
                  pushToCamera();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CameraInstruction()),
                  );
                }
              }

              //tapHour();
            },
            child: new Container(
                width: double.infinity,
                height: size.height * 0.40,
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
                      TimerBuilder.periodic(Duration(seconds: 1),
                          builder: (context) {
                        //print("${getSystemTime()}");
                        return Text(
                          getSystemTime(),
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white, letterSpacing: 1.5),
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                      Text(
                        stringTap,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.white, letterSpacing: 1.5),
                          fontSize: size.height < 569 ? 14 : 18,
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
                              fontSize: size.width <= 569 ? 20 : 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "WELCOME BACK! ",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.grey, letterSpacing: 0),
                                fontSize: size.width <= 569 ? 12 : 14,
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
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: colorPrimary,
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                          Image.asset("assets/images/ava.png")
                                              .image)))
                        ],
                      ))
                ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Task List",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                    fontSize: size.width <= 569 ? 20 : 22,
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
          SizedBox(
            height: 15,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(color: colorBackground, boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 10,
                )
              ]),
              child: Column(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(1.0),
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
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FlatButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: colorBackground,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Show All Task Schedule",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: colorPrimary,
                              )
                            ],
                          )))
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Meeting List",
                style: GoogleFonts.lato(
                    textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                    fontSize: size.width <= 569 ? 20 : 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 15,
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
          SizedBox(
            height: 15,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(color: colorBackground, boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 10,
                )
              ]),
              child: Column(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.all(1.0),
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
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FlatButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          color: colorBackground,
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Show All Meeting Schedule",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: colorPrimary,
                              )
                            ],
                          )))
                ],
              )),
          SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }

//Pop Up Dialog for Clock in and Out Confirmation
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
            dialogText + " Success!",
            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          SmallButton(
            bgColor: colorPrimary,
            textColor: colorBackground,
            title: "OK",
            onClick: () {
              Navigator.of(context, rootNavigator: true).pop();

              if (dialogText == "Clock Out") {
                disposeSF();
                dialogText = "Clock In";
                setState(() {
                  stringTap = "Tap Here to Clock In";
                });
                String timeClockOut = getHourNow();
                print(timeClockOut);
                Navigator.of(buildContext1, rootNavigator: true).pop();
                if (buildContext2 != null) {
                  Navigator.of(buildContext2, rootNavigator: true).pop();
                }
              }
            },
          ),
          // RaisedButton(
          //     onPressed: () {
          //       Navigator.of(context, rootNavigator: true).pop();
          //       if (dialogText == "Clock Out") {
          //         Navigator.of(buildContext1, rootNavigator: true).pop();
          //         Navigator.of(buildContext2, rootNavigator: true).pop();
          //       }
          //     },
          //     color: colorPrimary,
          //     child: Text(
          //       "OK!",
          //       style: TextStyle(color: colorBackground),
          //     ))
        ],
      ),
      actions: <Widget>[],
    );
  }

//Clock Out Step 1========================================
  BuildContext buildContext1, buildContext2;
  Widget _buildPopupClockOut(BuildContext context, {size}) {
    buildContext1 = context;
    return new AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Are you work overtime?",
            style: TextStyle(
                color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: LongButton(
              size: size,
              bgColor: colorPrimary,
              textColor: colorBackground,
              title: "Yes, I need Overtime Pay",
              onClick: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupOvertime(context, size: size));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: LongButton(
              size: size,
              bgColor: colorBackground,
              textColor: colorPrimary,
              title: "No, I Clocked  Out On Time",
              onClick: () {
                //Navigator.of(context).pop();
                dialogText = "Clock Out";
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context));
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[],
    );
  }

  Widget _buildPopupOvertime(BuildContext context, {size}) {
    buildContext2 = context;
    return new AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Overtime Paid Form",
            style: TextStyle(
                color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: colorPrimary, width: 2)),
                  child: Text("18.00",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary))),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: FaIcon(
                    Icons.arrow_forward,
                    color: colorPrimary,
                  )),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: colorSecondaryRed, width: 2)),
                  child: Text(getSystemTime(),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorSecondaryRed))),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(color: colorBackground, boxShadow: [
              BoxShadow(
                color: colorNeutral2.withOpacity(0.7),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
            width: double.infinity,
            child: TextFormField(
              controller: textReasonOvertime,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 5,
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Reason for Overtime',
                  hintStyle: TextStyle(fontSize: 14, color: colorNeutral2)),
            ),
          ),
          SizedBox(height: 10),
          LongButton(
            size: size,
            bgColor: colorPrimary,
            textColor: colorBackground,
            title: "Yes, I need Overtime Pay",
            onClick: () {
              dialogText = "Clock Out";
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context));
            },
          ),
          // Container(
          //   padding: EdgeInsets.only(top: 10),
          //   width: double.infinity,
          //   child: RaisedButton(
          //       onPressed: () {
          //         dialogText = "Clock Out";
          //         showDialog(
          //             context: context,
          //             builder: (BuildContext context) =>
          //                 _buildPopupDialog(context));
          //       },
          //       color: colorPrimary,
          //       child: Text(
          //         "Yes, I need Overtime Pay",
          //         style: TextStyle(
          //             color: colorBackground, fontWeight: FontWeight.bold),
          //       )),
          // ),
        ],
      ),
      actions: <Widget>[],
    );
  }

  void disposeSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, 0);
    clockIn = 0;
  }

  void sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clockIn = prefs.getInt(key);
    });
    if (clockIn == 1) {
      print("Clock in Success");
      stringTap = "Tap Here to Clock Out";
      String timeClockIn = getHourNow();
      print("Clock In Pegawai:" + timeClockIn);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context));
      });
    } else if (clockIn == 0) {
      print("Init Data");
    } else {
      print("Not Clock In Yet");
    }
  }

  String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getSystemTime() {
    var now = new DateTime.now();
    //print(now.toString);
    return new DateFormat("H:mm").format(now);
  }

  void sharedPrefInstruction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool("instruction") != null) {
        instruction = prefs.getBool("instruction");
        print("Instruction Closed");
      } else {
        print("Bool faield");
      }
    });
  }

  void pushToCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        String data = pickedFile.path;
        //print(data);
        //_image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewCamera(
                      path: data,
                    )));
      });
    }
  }
}
