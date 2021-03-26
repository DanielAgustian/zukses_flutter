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
import 'package:zukses_app_1/bloc/authentication/auth-bloc.dart';
import 'package:zukses_app_1/bloc/authentication/auth-event.dart';
import 'package:zukses_app_1/bloc/authentication/auth-state.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-event.dart';
import 'package:zukses_app_1/bloc/company-profile/company-state.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-bloc.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-state.dart';
import 'package:zukses_app_1/bloc/team/team-bloc.dart';
import 'package:zukses_app_1/bloc/team/team-event.dart';
import 'package:zukses_app_1/bloc/team/team-state.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/home/box-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/home/listviewbox.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/company-model.dart';
import 'package:zukses_app_1/punch-system/camera-clock-in.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/punch-system/camera-instruction.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-avatar.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/punch-system/camera-non-instruction.dart';
import 'package:zukses_app_1/screen/member/screen-member.dart';
import 'package:zukses_app_1/screen/profile/user-profile.dart';
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
  TextEditingController textProjectOvertime = new TextEditingController();
  final picker = ImagePicker();
  String statusLate = "";
  String statusOvertime = "";
  String key = "clock in";
  String stringTap = "Tap Here to Clock In";
  AuthModel _authModel = AuthModel();
  CompanyModel _company = CompanyModel();
  //For Disabling Button ============================//
  DateTime now = DateTime.now();
  String dialogText = "Clock In ";
  bool instruction = false;
  int isClockIn;
  int attendanceID;
  TimeOfDay _time = TimeOfDay.now();

// Dummy data
  var taskName = ["Task 1", "task 2"];
  var taskDetail = ["Task 1", "task 2"];
  var meetName = ["Meeting 1", "Meeting 2"];
  var meetTime = ["14:00-15:00", "19:00-20:00"];
  var enumTap = ["Tap Here to Clock In", "Tap Here to Clock Out", "Good Work!"];

  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;
  bool isLoadingAuth = false;
  bool stopLooping = false;
  bool changeTime = false;
  void timer() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void checkStatusClock(String where) async {
    if (where == "initState") {
      getAuthData();
    }
    if (isLoadingAuth) {
      setState(() {
        isLoading = false;
      });
    }
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

  void getMember() async {
    BlocProvider.of<TeamBloc>(context).add(LoadAllTeamEvent());
  }

  void getAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    print("username " + username);
    BlocProvider.of<AuthenticationBloc>(context)
        .add(AuthEventLoginManual(email: username, password: password));
  }

  void getCompanyProfile() async {
    BlocProvider.of<CompanyBloc>(context).add(CompanyEventGetProfile());
  }

  @override
  void initState() {
    super.initState();
    // sharedPref();
    getMember();
    //getAuthData();
    getCompanyProfile();
    sharedPrefInstruction();
    getUserProfile();
    checkStatusClock("initState");
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
          BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                if (state is AuthStateFailLoad) {
                  Util().showToast(
                      context: context,
                      msg: "Something Wrong!",
                      duration: 3,
                      color: colorError,
                      txtColor: colorBackground);
                } else if (state is AuthStateSuccessLoad) {
                  setState(() {
                    _authModel = state.authUser;
                    isLoadingAuth = true;
                  });
                  if (_authModel.maxClockIn == "true") {
                    setState(() {
                      stringTap = enumTap[2];
                    });
                  }
                  if (_authModel.maxClockIn == "false") {
                    if (_authModel.attendance == "false") {
                      setState(() {
                        //stringTap = enumTap[0];
                      });
                    } else if (_authModel.attendance == "true") {
                      setState(() {
                        stringTap = enumTap[1];
                      });
                    }
                  } else if (_authModel.maxClockIn == "true") {
                    setState(() {
                      stringTap = enumTap[2];
                    });
                  } else {
                    print("Get Auth Data Error");
                  }
                  /*print("attendance auth" + _authModel.attendance);
                  print("MaxClockIn " + _authModel.maxClockIn);*/

                  checkStatusClock("Get Auth Data");
                }
              },
              child: Container()),
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) async {
              getAuthData();
              if (state is AttendanceStateFailed) {
                Util().showToast(
                    context: this.context,
                    msg: "Something Wrong !",
                    color: colorError,
                    txtColor: colorBackground);
              } else if (state is AttendanceStateSuccessClockIn) {
                // sharedPref();
                setState(() {
                  stringTap = enumTap[1];
                });
              } else if (state is AttendanceStateSuccessClockOut) {
                print("clock out");

                int counter = 2;
                /*SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt(key, counter);*/
                setState(() {
                  isClockIn = 2;
                  attendanceID = state.attendanceID;
                  stringTap = enumTap[2];
                });
                // // show confirm dialog success clock out
                showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context, "_BlocListener"))
                    .then((value) => stringTap = enumTap[2]);
              }
            },
            child: Container(),

            ///
          ),
          BlocListener<CompanyBloc, CompanyState>(
            listener: (context, state) async {
              if (state is CompanyStateSuccessLoad) {
                _company = state.company;
                print("Company Model: " + _company.name);
              } else if (state is CompanyStateLoading) {
              } else {}
            },
            child: Container(),
          ),
          isLoading
              // FOR SKELETON LOADING
              ? skeletonSection(size)
              // LIMIT FOR THE REAL COMPONENT
              : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        /*print("Container clicked $isClockIn");
                      if (isClockIn == 1) {
                        confirmClockOut(size: size);
                      } else if (isClockIn == 2) {
                        print("masuk sini");
                        // DO nothing
                        // lock repeatable checkin in the same day
                      } else {*/
                        if (stringTap != enumTap[2]) {
                          if (_authModel.maxClockIn != null &&
                              _authModel.attendance != null) {
                            if (_authModel.maxClockIn == "false") {
                              if (_authModel.attendance == "false") {
                                //Clock In
                                if (instruction == true) {
                                  pushToCamera();
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CameraInstruction()),
                                  );
                                }
                              } else if (_authModel.attendance == "true") {
                                //Clock Out
                                int diff =
                                    timeCalculation(_company.endOfficeTime);
                                //if employee clock out before office closing time
                                if (diff < 0) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildClockOutNotFinished(
                                              context, size));
                                } else {
                                  confirmClockOut(size: size);
                                }
                              } else {
                                print(_authModel.attendance);
                                print("Error Data");
                              }
                            } else {
                              //Have A Good Day!
                              setState(() {
                                stringTap = enumTap[2];
                              });
                            }
                          } else {
                            getAuthData();
                          }
                        }

                        //}
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            child: InkWell(
                              onTap: () {
                                if (_company != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                            company: _company,
                                            user: state.userModel),
                                      ));
                                } else {
                                  Util().showToast(
                                      msg: "Company Empty!",
                                      color: colorError,
                                      txtColor: colorBackground,
                                      context: context,
                                      duration: 3);
                                }
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hi, $name",
                                            style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: colorPrimary,
                                                    letterSpacing: 0),
                                                fontSize:
                                                    size.width <= 600 ? 20 : 24,
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
                                                  fontSize: size.width <= 600
                                                      ? 12
                                                      : 14,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.solidBell,
                                          size: size.height < 569 ? 18 : 25,
                                          color: colorPrimary,
                                        ),
                                        SizedBox(
                                          width: size.height < 569 ? 10 : 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                            )),
                                      ],
                                    )
                                  ]),
                            ),
                          );
                        } else if (state is UserDataFailLoad) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hi, Finley Khouwira",
                                        style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                                color: colorPrimary,
                                                letterSpacing: 0),
                                            fontSize:
                                                size.width <= 600 ? 20 : 24,
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
                      child: BlocBuilder<TeamBloc, TeamState>(
                        builder: (context, state) {
                          if (state is TeamStateSuccessLoad) {
                            return Container(
                              width: size.width,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  color: colorBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadowStandard]),
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
                                        itemCount: state.team.length,
                                        itemBuilder: (context, index) =>
                                            index >= 9
                                                ? UserAvatar(
                                                    value: "+" +
                                                        (state.team.length - 9)
                                                            .toString(),
                                                  )
                                                : UserAvatar(dotSize: 7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Task List",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: colorPrimary, letterSpacing: 0),
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
                        decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [boxShadowStandard]),
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
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenTab(index: 2)));
                                    },
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
                              textStyle: TextStyle(
                                  color: colorPrimary, letterSpacing: 0),
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
                        decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [boxShadowStandard]),
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
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScreenTab(index: 3)));
                                    },
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
                  SkeletonAnimation(
                    shimmerColor: colorNeutral170,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorSkeleton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.4,
                      height: 20,
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
                        color: colorSkeleton,
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
                        color: colorSkeleton,
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
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: colorBackground, boxShadow: [boxShadowStandard]),
          width: size.width,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                      decoration: BoxDecoration(
                        color: colorSkeleton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.4,
                      height: 20)),
              SizedBox(
                height: 10,
              ),
              SkeletonAnimation(
                  shimmerColor: colorNeutral170,
                  child: Container(
                      decoration: BoxDecoration(
                        color: colorSkeleton,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: size.width * 0.7,
                      height: 20)),
            ],
          ),
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
            decoration: BoxDecoration(
                color: colorBackground, boxShadow: [boxShadowStandard]),
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
            decoration: BoxDecoration(
                color: colorBackground, boxShadow: [boxShadowStandard]),
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
  Widget _buildPopupDialog(BuildContext context, String where) {
    Size sizeDialog = MediaQuery.of(context).size;
    return new CupertinoAlertDialog(
      title: new Text(
        "Clock Out Success!",
      ),
      content: new Text("Clock Out in" + getSystemTime()),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              // if (dialogText == "Clock Out") {
              //disposeSF();
              setState(() {
                //dialogText = "Clock In";
                isClockIn = 2;
                stringTap = enumTap[2];
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
                //timeCalculation(1);
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
                          _buildPopupDialog(context, "_buildPopUpClockOut"));
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

  //POPUP OVERTIME FORM
  Widget _buildPopupOvertime(BuildContext context, {size}) {
    buildContext2 = context;
    String timeOvertime = getSystemTime();
    return AlertDialog(
      content: StatefulBuilder(// You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Overtime Paid Form",
                style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: colorPrimary, width: 2)),
                      child: Text(formatOfficeTime(_company.endOfficeTime),
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
                  InkWell(
                    onTap: () async {
                      TimeOfDay newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      );
                      if (newTime != null) {
                        setState(() {
                          _time = newTime;
                          String data = _time.format(context);
                          DateTime date = DateFormat.jm().parse(data);
                          setState(() => timeOvertime =
                              DateFormat("HH:mm:ss").format(date));

                          print("TIme Overtime:" + timeOvertime);
                        });
                      }
                      setState(() {
                        changeTime = true;
                      });
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: colorSecondaryRed, width: 2)),
                        child: Text(
                            changeTime
                                ? formatOfficeTime(timeOvertime)
                                : timeOvertime,
                            style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorSecondaryRed))),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: colorBackground, boxShadow: [boxShadowStandard]),
                width: double.infinity,
                child: TextFormField(
                  controller: textProjectOvertime,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      hintText: 'Project',
                      hintStyle: TextStyle(fontSize: 14, color: colorNeutral2)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: colorBackground, boxShadow: [boxShadowStandard]),
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
                  if (textProjectOvertime.text != "" &&
                      textReasonOvertime.text != "") {
                    //timeCalculation(1);
                    setState(() {
                      dialogText = "Clock Out";
                    });
                    BlocProvider.of<OvertimeBloc>(context).add(AddOvertimeEvent(
                        attendanceId: attendanceID,
                        project: textProjectOvertime.text,
                        reason: textReasonOvertime.text));

                    Navigator.pop(context);
                  } else {
                    Util().showToast(
                        context: context,
                        duration: 3,
                        msg: "Project and Reason for Overtime can't be empty",
                        color: colorSecondaryRed);
                  }
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
                  } else if (state is OvertimeStateLoading) {
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
        );
      }),
      actions: <Widget>[],
    );
  }

  Widget _buildClockOutNotFinished(BuildContext context, Size size) {
    Size sizeDialog = MediaQuery.of(context).size;
    return new CupertinoAlertDialog(
      title: new Text(
        "Your work hour isn't finished yet",
      ),
      content: new Text("Are you sure you want to clock out?"),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "Yes",
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context);
              clockOut();
            }),
        CupertinoDialogAction(
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  String getSystemTime() {
    var now = new DateTime.now();

    return new DateFormat("HH:mm").format(now);
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CameraNonInstruction()));
  }

  String formatOfficeTime(String tod) {
    TimeOfDay timeTemp = Util().stringToTimeOfDay(tod);
    return Util().changeTimeToString(timeTemp);
  }

  int timeCalculation(String endOfficeString) {
    TimeOfDay now = TimeOfDay.now();
    if (_company.endOfficeTime != null) {
      TimeOfDay endOfficeTime = Util().stringToTimeOfDay(endOfficeString);
      int diffHour = ((now.hour * 60) + now.minute) -
          ((endOfficeTime.hour * 60) + endOfficeTime.minute);
      return diffHour;
    } else {
      print("Error Get Data");
      return 86400;
    }
  }
}
