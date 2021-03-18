import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-bloc.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-state.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/home/box-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/home/listviewbox.dart';
import 'package:zukses_app_1/punch-system/camera-clock-in.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/punch-system/camera-instruction.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-avatar.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/screen/member/screen-member.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

/*
  ========== IMPORTANT NOTE ==============
  Check in status :
    - 0 : reset status or usually for start a new check in in a new day
    - 1 : user has been clock in in that day
    - 2 : user has been clock ot in that day and disable a repeat `clock in` at same day
*/

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
  String statusLate = "";
  String statusOvertime = "";
  String key = "clock in";
  String stringTap = "Click Here to Clock In";

  //For Disabling Button ============================//
  DateTime now = DateTime.now();
  String dialogText = "Clock In ";
  bool instruction = false;
  int isClockIn;
  int attendanceID;

// Dummy data
  var taskName = ["Task 1", "task 2"];
  var taskDetail = ["Task 1", "task 2"];
  var meetName = ["Meeting 1", "Meeting 2"];
  var meetTime = ["14:00-15:00", "19:00-20:00"];

  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;

  void timer() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void checkStatusClock() async {
    timer();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString("token");
    int checkDate = prefs.getInt("tanggal");
    int clockStatus = prefs.getInt("clock in");

    print("tanggal sama ? $checkDate");
    print("status apa ? $clockStatus");
    setState(() {
      // is the date in shared pref is same as now ?
      isClockIn = (checkDate == now.day) ? clockStatus : 0;

      if (clockStatus == 1) {
        stringTap = "Tap Here to Clock Out";
      } else if (clockStatus == 2) {
        stringTap = "Have a Nice Day !";
      }
    });
    // print(token);
  }

  void confirmClockOut({Size size}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupClockOut(context, size: size));
  }

  void clockOut() async {
    BlocProvider.of<AttendanceBloc>(context).add(AttendanceClockOut());
  }

  void getUserProfile() async {
    BlocProvider.of<UserDataBloc>(context).add(UserDataGettingEvent());
  }

  @override
  void initState() {
    super.initState();
    // sharedPref();
    sharedPrefInstruction();
    checkStatusClock();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: isLoading
          // FOR SKELETON LOADING
          ? skeletonSection(size)
          // LIMIT FOR THE REAL COMPONENT
          : SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocListener<AttendanceBloc, AttendanceState>(
                  listener: (context, state) async {
                    if (state is AttendanceStateFailed) {
                      Util().showToast(
                          context: this.context,
                          msg: "Something Wrong !",
                          color: colorError,
                          txtColor: colorBackground);
                    } else if (state is AttendanceStateSuccessClockIn) {
                      // sharedPref();
                      setState(() {
                        isClockIn = 1;
                        stringTap = "Tap Here to Clock Out";
                      });

                      print("Masuk sini ! $isClockIn");
                    } else if (state is AttendanceStateSuccessClockOut) {
                      print("clock out");
                      int counter = 2;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt(key, counter);

                      setState(() {
                        isClockIn = 2;
                        attendanceID = state.attendanceID;
                        stringTap = "Have a nice day";
                      });
                      // // show confirm dialog success clock out
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialog(context));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      print("Container clicked $isClockIn");
                      if (isClockIn == 1) {
                        confirmClockOut(size: size);
                      } else if (isClockIn == 2) {
                        print("masuk sini");
                        // DO nothing
                        // lock repeatable checkin in the same day
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
                    },
                    // Bloc listener for attendance
                    child: Container(
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
                                return Text(
                                  getSystemTime(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: size.height < 600 ? 56 : 72,
                                      fontWeight: FontWeight.w500),
                                );
                              }),
                              Text(
                                stringTap,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontSize: size.height < 600 ? 14 : 18,
                                ),
                              ),
                            ]))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //======================BlocBuilder===========================
                BlocBuilder<UserDataBloc, UserDataState>(
                  builder: (context, state) {
                    if (state is UserDataStateLoading) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonAnimation(
                                      shimmerColor: colorNeutral170,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorNeutral2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: size.width * 0.6,
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SkeletonAnimation(
                                      shimmerColor: colorNeutral170,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorNeutral2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: size.width * 0.6,
                                        height: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SkeletonAvatar()
                            ]),
                      );
                    } else if (state is UserDataStateSuccessLoad) {
                      String name = state.userModel.name == null
                          ? "Username"
                          : state.userModel.name;
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hi, $name",
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: colorPrimary,
                                              letterSpacing: 0),
                                          fontSize: size.width <= 600 ? 20 : 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "WELCOME BACK! ",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: Colors.grey,
                                                letterSpacing: 0),
                                            fontSize:
                                                size.width <= 600 ? 12 : 14,
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
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: Image.asset(
                                                          "assets/images/ava.png")
                                                      .image)))
                                    ],
                                  ))
                            ]),
                      );
                    } else if (state is UserDataFailLoad) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonAnimation(
                                      shimmerColor: colorNeutral170,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorNeutral2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: size.width * 0.6,
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    SkeletonAnimation(
                                      shimmerColor: colorNeutral170,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorNeutral2,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: size.width * 0.6,
                                        height: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SkeletonAvatar()
                            ]),
                      );
                    }

                    return Container(
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
                                            color: colorPrimary,
                                            letterSpacing: 0),
                                        fontSize: size.width <= 600 ? 20 : 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "WELCOME BACK! ",
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color: Colors.grey,
                                              letterSpacing: 0),
                                          fontSize: size.width <= 600 ? 12 : 14,
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
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: Image.asset(
                                                        "assets/images/ava.png")
                                                    .image)))
                                  ],
                                ))
                          ]),
                    );
                  },
                ),

                //====================BlocBuilder=================================///
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MemberScreen()));
                  },
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: colorNeutral1.withOpacity(1),
                            blurRadius: 15,
                          )
                        ]),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Team Member",
                            style: TextStyle(
                                color: colorPrimary,
                                letterSpacing: 0,
                                fontSize: size.width <= 600 ? 18 : 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 20,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, index) => index >= 9
                                  ? UserAvatar(
                                      value: "+5",
                                    )
                                  : UserAvatar(dotSize: 7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Task List",
                      style: GoogleFonts.lato(
                          textStyle:
                              TextStyle(color: colorPrimary, letterSpacing: 0),
                          fontSize: size.width <= 600 ? 20 : 22,
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
                          loading: isLoading,
                          title: "High Priority Task",
                          total: 8,
                          numberColor: colorSecondaryRed,
                          fontSize: size.width <= 600 ? 34 : 36,
                        ),
                        BoxHome(
                            loading: isLoading,
                            title: "Low Priority Task",
                            total: 8,
                            numberColor: colorClear,
                            fontSize: size.width <= 600 ? 34 : 36),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration:
                        BoxDecoration(color: colorBackground, boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 10,
                      )
                    ]),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          textStyle:
                              TextStyle(color: colorPrimary, letterSpacing: 0),
                          fontSize: size.width <= 600 ? 20 : 22,
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
                            loading: isLoading,
                            title: "Meeting Schedule",
                            total: 3,
                            numberColor: colorSecondaryRed,
                            fontSize: size.width <= 600 ? 34 : 36),
                        BoxHome(
                            loading: isLoading,
                            title: "Meeting Request",
                            total: 11,
                            numberColor: colorSecondaryYellow,
                            fontSize: size.width <= 600 ? 34 : 36),
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration:
                        BoxDecoration(color: colorBackground, boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 10,
                      )
                    ]),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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

  // Widget for skeleton loader
  Widget skeletonSection(Size size) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
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
                    return Text(
                      getSystemTime(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: size.height < 600 ? 56 : 72,
                          fontWeight: FontWeight.w500),
                    );
                  }),
                  Text(
                    stringTap,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white),
                      fontSize: size.height < 600 ? 14 : 18,
                    ),
                  ),
                ]))),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAnimation(
                    shimmerColor: colorNeutral170,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorNeutral2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.6,
                      height: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SkeletonAnimation(
                    shimmerColor: colorNeutral170,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorNeutral2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.6,
                      height: 10,
                    ),
                  ),
                ],
              ),
            ),
            SkeletonAvatar()
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
                  fontSize: size.width <= 600 ? 18 : 20,
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
                BoxHome(loading: isLoading),
                BoxHome(loading: isLoading),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(color: colorBackground, boxShadow: [
              BoxShadow(
                color: colorNeutral1.withOpacity(1),
                blurRadius: 10,
              )
            ]),
            child: Column(
              children: [
                // manual loop for skeleton
                ...taskName.map((item) => SkeletonLess3(
                      size: size,
                      row: 2,
                      col: 1,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FlatButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: colorBackground,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      (ScreenTab(index: 3))));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Show All Task Schedule",
                                style: TextStyle(color: colorPrimary)),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colorPrimary,
                            )
                          ],
                        )))
              ],
            )),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Meeting List",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(color: colorPrimary, letterSpacing: 0),
                  fontSize: size.width <= 600 ? 18 : 20,
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
                BoxHome(loading: isLoading),
                BoxHome(loading: isLoading),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(color: colorBackground, boxShadow: [
              BoxShadow(
                color: colorNeutral1.withOpacity(1),
                blurRadius: 10,
              )
            ]),
            child: Column(
              children: [
                // manual loop for skeleton
                ...taskName.map((item) => SkeletonLess3(
                      size: size,
                      row: 2,
                      col: 1,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FlatButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: colorBackground,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      (ScreenTab(index: 2))));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Show All Task Schedule",
                                style: TextStyle(color: colorPrimary)),
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
    ));
  }

//Pop Up Dialog for Clock in and Out Confirmation
  Widget _buildPopupDialog(BuildContext context) {
    Size sizeDialog = MediaQuery.of(context).size;
    return new CupertinoAlertDialog(
      title: new Text(
        "Clock Out Success!",
      ),
      content: new Text("This is my content"),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              // if (dialogText == "Clock Out") {
              disposeSF();
              setState(() {
                //dialogText = "Clock In";
                stringTap = "Have a nice day !";
              });
              String timeClockOut = getSystemTime();
              print(timeClockOut);
              // }
            })
      ],
    );
  }

  // Clock Out Step 1========================================
  BuildContext buildContext1, buildContext2;
  Widget _buildPopupClockOut(BuildContext context, {size}) {
    print("dialog clock out");
    buildContext1 = context;
    return new AlertDialog(
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
                timeCalculation(1);
                Navigator.pop(context);
                clockOut();
                if (statusOvertime != "No") {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupOvertime(context, size: size));
                } else {
                  setState(() {
                    dialogText = "Clock Out";
                  });

                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context));
                }
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
                dialogText = "Clock Out";
                Navigator.pop(context);
                clockOut();
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
                  child: Text("18:00",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                          letterSpacing: 1))),
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
                          letterSpacing: 1,
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
                color: colorNeutral1.withOpacity(1),
                blurRadius: 15,
              )
            ]),
            width: double.infinity,
            child: TextFormField(
              controller: textReasonOvertime,
              keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 6,
              decoration: new InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
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
              timeCalculation(1);
              setState(() {
                dialogText = "Clock Out";
              });
              BlocProvider.of<OvertimeBloc>(context).add(AddOvertimeEvent(
                  attendanceId: attendanceID,
                  project: "Testing Data",
                  reason: textReasonOvertime.text));
              //clockOut();
              Navigator.pop(context);
            },
          ),
          BlocListener<OvertimeBloc, OvertimeState>(
            listener: (context, state) async {
              if (state is OvertimeStateSuccess) {
                Util().showToast(
                    context: this.context,
                    msg: "Overtime Created !",
                    color: Colors.blueAccent,
                    txtColor: colorBackground);
              } else {
                Util().showToast(
                    context: this.context,
                    msg: "Overtime Failed !",
                    color: colorError,
                    txtColor: colorBackground);
              }
            },
            child: Container(),
          )
        ],
      ),
      actions: <Widget>[],
    );
  }

  void disposeSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, 0);
    isClockIn = 0;
  }

  void sharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isClockIn = prefs.getInt(key);
    });

    // if (isClockIn == 1) {
    print("Clock in Success $isClockIn");
    setState(() {
      stringTap = "Tap Here to Clock Out";
    });
    timeCalculation(0);
    String timeClockIn = getSystemTime();
    print("Clock In Pegawai:" + timeClockIn);
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewCamera(
                      path: data,
                    )));
      });
    }
  }

  //for calculate if someone is late or overtime.
  void timeCalculation(int i) {
    TimeOfDay now = TimeOfDay.now();
    int minutesTotalNow = (now.hour * 60) + (now.minute);
    print(now.hour);
    print(now.minute);

    if (i == 0) {
      //Lateness
      int limitLate = (9 * 60);
      int minutesLate = 0;
      if (minutesTotalNow <= limitLate) {
        setState(() {
          statusLate = "In Time";
        });
      } else {
        setState(() {
          statusLate = "Late";
          minutesLate = minutesTotalNow - limitLate;
        });
      }
      print("Status Late = " + statusLate);
    } else if (i == 1) {
      //Overtime
      int limitOvertime = (10 * 60);
      if (minutesTotalNow <= limitOvertime) {
        setState(() {
          statusOvertime = "No";
        });
      } else {
        setState(() {
          statusOvertime = "Yes";
        });

        int duration = minutesTotalNow - limitOvertime;
        int hour = (duration / 60).floor();
        int minutes = duration % 60;
        String data = hour.toString() + "jam " + minutes.toString() + "menit";
      }
      print("status Overtime = " + statusOvertime);
    }
  }
}
