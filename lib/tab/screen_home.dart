import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

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
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-bloc.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-event.dart';
import 'package:zukses_app_1/bloc/meeting-req/meeting-req-state.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-bloc.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-state.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-bloc.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-event.dart';
import 'package:zukses_app_1/bloc/task-priority/task-priority-state.dart';
import 'package:zukses_app_1/bloc/task/task-bloc.dart';
import 'package:zukses_app_1/bloc/task/task-event.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-bloc.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-event.dart';
import 'package:zukses_app_1/bloc/team-detail/team-detail-state.dart';
import 'package:zukses_app_1/bloc/team/team-bloc.dart';
import 'package:zukses_app_1/bloc/team/team-event.dart';
import 'package:zukses_app_1/bloc/team/team-state.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/home/box-home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/home/listviewbox.dart';
import 'package:zukses_app_1/model/auth-model.dart';
import 'package:zukses_app_1/model/company-model.dart'; 
import 'package:zukses_app_1/model/fb_model_sender.dart';
import 'package:zukses_app_1/model/google-sign-in-model.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:zukses_app_1/model/team-detail-model.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/punch-system/camera-instruction.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-avatar.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/screen/punch-system/camera-non-instruction.dart';
import 'package:zukses_app_1/screen/member/screen-member.dart';
import 'package:zukses_app_1/screen/profile/user-profile.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
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
  HomeScreen({Key key, this.title, this.link}) : super(key: key);
  final String title;
  final Uri link;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the stateless widget that the main application instantiates.
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TextEditingController textReasonOvertime = new TextEditingController();
  TextEditingController textProjectOvertime = new TextEditingController();

  final picker = ImagePicker();
  String statusLate = "";
  String statusOvertime = "";
  String key = "clock in";
  String stringTap = "home_text1".tr();
  String teamId = "";
  AuthModel _authModel = AuthModel();
  CompanyModel _company = CompanyModel();
  List<ScheduleModel> _scheduleAccepted = [];
  int scheduleReqLength = 0;
  List<TaskModel> _taskHighPriority = [];
  int lengthLowPriority = 0, lengthHighPriority = 0;
  //For Disabling Button ============================//
  DateTime now = DateTime.now();
  String dialogText = "Clock In ";
  bool instruction = false;
  int isClockIn;
  int attendanceID;
  int totalClockOut = 0;
  TimeOfDay _time = TimeOfDay.now();
  Util util = Util();

// Dummy data
  var taskName = ["Task 1", "task 2"];
  var taskDetail = ["Task 1", "task 2"];
  var meetName = ["Meeting 1", "Meeting 2"];
  var meetTime = ["14:00-15:00", "19:00-20:00"];
  var enumTap = ["home_text1".tr(), "home_text3".tr(), "home_text2".tr()];
  //bool emptyMeeting = false;
  //bool emptyTask = false;
  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;
  bool isLoadingAuth = false;
  bool stopLooping = false;
  bool changeTime = false;

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  DateTime backbuttonpressedTime;

  String tokenFCM = "";
  String companyID = "";
  int companyAcceptance = 0;

  void checkStatusClock(String where) async {
    if (where == "initState") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var googleSign = prefs.getInt('google');
      var facebookSign = prefs.getInt('facebook');
      // print("Allow Google Sign " + googleSign.toString());
      if (googleSign != null) {
        getAuthGoogle();
      } else if (facebookSign != null) {
        getAuthFacebook();
      } else {
        getAuthData();
      }
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
    // await _getTokenFCM();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    // print("username " + username);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginManual(
        email: username, password: password, tokenFCM: tokenFCM));
  }

  void getAuthGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('google_data');
    GoogleSignInModel model = GoogleSignInModel.fromJson(jsonDecode(data));
    // print("Email from Google = " + model.email);
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventDetectGoogleSignIn(
            email: model.email,
            name: model.name,
            image: model.image,
            tokenGoogle: model.token,
            tokenFCM: tokenFCM));
  }

  void getAuthFacebook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('facebook_data');

    String tokenFacebook = prefs.getString('facebook_token');
    FBModelSender model = FBModelSender.fromJson(jsonDecode(data));

    // print("Email from facebook = " + model.email);
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventDetectGoogleSignIn(
            email: model.email,
            name: model.name,
            image: model.url,
            tokenGoogle: tokenFacebook,
            tokenFCM: tokenFCM));
  }

  void loginTeam() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    String link = await util.createDynamicLink2(
        short: false, link: widget.link.toString());
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventLoginTeam(email: username, password: password, link: link));
  }

  void getCompanyProfile() async {
    BlocProvider.of<CompanyBloc>(context).add(CompanyEventGetProfile());
  }

  void _getMeetingToday() async {
    BlocProvider.of<MeetingBloc>(context).add(GetAcceptedMeetingEvent());
  }

  void _getMeetingRequest() async {
    BlocProvider.of<MeetingReqBloc>(context).add(LoadAllMeetingReqEvent());
  }

  void _getTeamDetail(String id) async {
    BlocProvider.of<TeamDetailBloc>(context).add(LoadAllTeamDetailEvent("12"));
  }

  void _getTaskLowPriority() async {
    BlocProvider.of<TaskBloc>(context).add(LoadLowPriorityTaskEvent("low"));
  }

  void _getTaskHighPriority() async {
    BlocProvider.of<TaskPriorityBloc>(context)
        .add(LoadHighPriorityEvent("high"));
  }

  void _getTokenFCM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenFCM = prefs.getString('fcmToken');
    });
    // print("TOKEN FCM =>>>>>>>>>>>>>>>>>>> $tokenFCM");
  }

  @override
  void initState() {
    super.initState();
    _getTokenFCM();
    getMember();
    checkStatusClock("initState");
    getCompanyProfile();
    sharedPrefInstruction();
    getUserProfile();
    _getTaskLowPriority();
    _getTaskHighPriority();

    _getMeetingToday();
    _getMeetingRequest();
    getCompanyAcceptance();
    _controller = AnimationController(vsync: this, duration: _duration);
    Util().initDynamicLinks(context);
    if (widget.link != null) {
      teamId = widget.link.queryParameters['teamId'];
      _controller.forward();
      _getTeamDetail(teamId);
    }
  }

  getCompanyAcceptance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      companyAcceptance = prefs.getInt("in-company");
      companyID = prefs.getString("company_id");
    });
    if (companyID != "" && companyAcceptance == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WaitRegisApproved()),
          (route) => false);
    }
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
    if (backButton) {
      backbuttonpressedTime = currentTime;
      util.showToast(
          msg: "Double Click to exit app",
          duration: 3,
          context: context,
          txtColor: colorBackground,
          color: Colors.black);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocListener<MeetingReqBloc, MeetingReqState>(
                  listener: (context, state) async {
                    if (state is MeetingReqStateSuccessLoad) {
                      setState(() {
                        scheduleReqLength = state.schedule.length;
                      });
                    }
                  },
                  child: Container(),
                ),
                BlocListener<MeetingBloc, MeetingState>(
                    listener: (context, state) async {
                      if (state is MeetingStateSuccessLoad) {
                        setState(() {
                          _scheduleAccepted.clear();
                          state.meetings.forEach((element) {
                            if (util.yearFormat(now) ==
                                util.yearFormat(element.date)) {
                              _scheduleAccepted.add(element);
                            }
                          });
                          if (_scheduleAccepted.length < 1) {
                            print("No Data");
                          }
                        });
                      }
                    },
                    child: Container()),
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

                        if (_authModel.maxClockIn == "false") {
                          //if they arent clockout today
                          if (_authModel.attendance == "false") {
                            // if they arent clock in yet
                            // setState(() {
                            //   stringTap = enumTap[0];
                            // });
                          } else if (_authModel.attendance == "true") {
                            // if they already clock in.
                            setState(() {
                              stringTap = enumTap[1];
                            });
                          }
                        } else if (_authModel.maxClockIn == "true") {
                          //If they already clock out for today
                          setState(() {
                            stringTap = enumTap[2];
                          });
                        } else {
                          print("Get Auth Data Error");
                        }
                        checkStatusClock("Get Auth Data");
                      } else if (state is AuthStateSuccessTeamLoad) {
                        _controller.reverse();
                      }
                    },
                    child: Container()),
                BlocListener<AttendanceBloc, AttendanceState>(
                  listener: (context, state) async {
                    if (state is AttendanceStateFailed) {
                      Util().showToast(
                          context: this.context,
                          msg: "Something Wrong !",
                          color: colorError,
                          txtColor: colorBackground);
                    } else if (state is AttendanceStateSuccessClockIn) {
                      //if they already clock in
                      setState(() {
                        stringTap = enumTap[1];
                      });
                    } else if (state is AttendanceStateSuccessClockOut) {
                      print("clock out");
                      //if they already clock out
                      setState(() {
                        isClockIn = 2;
                        attendanceID = state.attendanceID;
                        stringTap = enumTap[2];
                      });
                      // show confirm dialog success clock out
                      if (totalClockOut < 1) {
                        showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context, "_BlocListener"))
                            .then((value) => stringTap = enumTap[2]);
                      }
                      totalClockOut = totalClockOut + 1;
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
                BlocListener<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskStateLowPrioritySuccessLoad) {
                      setState(() {
                        lengthLowPriority = state.task.length;
                      });
                    }
                  },
                  child: Container(),
                ),
                BlocListener<TaskPriorityBloc, TaskPriorityState>(
                  listener: (context, state) {
                    if (state is TaskPriorityStateSuccessLoad) {
                      setState(() {
                        lengthHighPriority = state.task.length;
                      });
                      for (int i = 0; i < state.task.length; i++) {
                        _taskHighPriority.add(state.task[i]);
                      }
                    }
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
                              if (companyAcceptance == 1) {
                                if (stringTap != enumTap[2]) {
                                  if (_authModel.maxClockIn != null &&
                                      _authModel.attendance != null) {
                                    if (_authModel.maxClockIn == "false") {
                                      if (_authModel.attendance == "false") {
                                        if (instruction == true) {
                                          pushToCamera();
                                          print("Push To Camera");
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CameraInstruction()),
                                          );
                                        }
                                        checkStatusClock("initState");
                                      } else if (_authModel.attendance ==
                                          "true") {
                                        //Clock Out
                                        int diff = timeCalculation(
                                            _company.endOfficeTime);
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
                                  }
                                }
                              }
                            },
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      TimerBuilder.periodic(
                                          Duration(seconds: 1),
                                          builder: (context) {
                                        return Text(
                                          getSystemTime(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 1.5,
                                              fontSize:
                                                  size.height < 600 ? 56 : 72,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: colorBackground,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: companyAcceptance == 1
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                        "assets/images/tap-clock-in.svg",
                                                        width: size.height < 569
                                                            ? 20
                                                            : 25,
                                                        height:
                                                            size.height < 569
                                                                ? 20
                                                                : 25),
                                                    // SizedBox(width: 10),
                                                    Text(
                                                      stringTap,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorPrimary,
                                                          fontSize:
                                                              size.height < 600
                                                                  ? 14
                                                                  : 16),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "Welcome to Zukses!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: colorPrimary,
                                                            fontSize:
                                                                size.height <
                                                                        600
                                                                    ? 14
                                                                    : 16),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                    ]))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //======================BlocBuilder Profile User===========================
                          buildHeaderProfile(size),

                          //====================BlocBuilder Team =================================
                          SizedBox(height: 20),
                          buildTeamWidget(context, size),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "home_text6".tr(),
                                style: TextStyle(
                                    color: colorPrimary,
                                    letterSpacing: 0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BoxHome(
                                    loading: isLoading,
                                    title: "home_text7".tr(),
                                    total: lengthHighPriority,
                                    numberColor: colorSecondaryRed,
                                    fontSize: size.width <= 600 ? 34 : 36,
                                  ),
                                  BoxHome(
                                      loading: isLoading,
                                      title: "home_text8".tr(),
                                      total: lengthLowPriority,
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
                                  _taskHighPriority.length < 1
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "No High Priority Task",
                                              style: TextStyle(
                                                  color: colorPrimary,
                                                  fontSize: size.height < 569
                                                      ? 12
                                                      : 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.all(1.0),
                                          itemCount:
                                              _taskHighPriority.length > 2
                                                  ? 2
                                                  : _taskHighPriority.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListViewBox(
                                              title: _taskHighPriority[index]
                                                  .taskName,
                                              detail: _taskHighPriority[index]
                                                  .details,
                                              viewType: "task",
                                            );
                                          },
                                        ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              primary: colorBackground),
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
                                              Text(
                                                  "home_text7"
                                                      .tr(args: ["Task"]),
                                                  style: TextStyle(
                                                      color: colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                "home_text10".tr(),
                                style: TextStyle(
                                    color: colorPrimary,
                                    letterSpacing: 0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BoxHome(
                                      loading: isLoading,
                                      title: "home_text11".tr(),
                                      total: _scheduleAccepted.length,
                                      numberColor: colorSecondaryRed,
                                      fontSize: size.width <= 600 ? 34 : 36),
                                  BoxHome(
                                      loading: isLoading,
                                      title: "meeting request".tr(),
                                      total: scheduleReqLength,
                                      numberColor: colorSecondaryYellow,
                                      fontSize: size.width <= 600 ? 34 : 36),
                                ],
                              )),
                          SizedBox(
                            height: 15,
                          ),

                          _listViewMeeting(_scheduleAccepted, size),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      )
              ],
            )),
            BlocBuilder<TeamDetailBloc, TeamDetailState>(
                builder: (context, state) {
              if (state is TeamDetailStateSuccess) {
                return scrollInvitation(context, size, state.team);
              }
              return Container();
            })
          ],
        ),
      ),
    );
  }

  Widget buildTeamWidget(BuildContext context, Size size) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MemberScreen()));
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
                      "home_text5".tr(),
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
                        itemBuilder: (context, index) => index >= 9
                            ? UserAvatar(
                                value: "+" + (state.team.length - 9).toString(),
                              )
                            : UserAvatar(
                                dotSize: 7, status: state.team[index].late),
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
    );
  }

  Widget buildHeaderProfile(Size size) {
    return BlocBuilder<UserDataBloc, UserDataState>(
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
          );
        } else if (state is UserDataStateSuccessLoad) {
          String name =
              state.userModel.name == null ? "Username" : state.userModel.name;
          if (name.length > 15) {
            var parts = name.split(" ");
            name = parts[0];
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                if (_company != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(
                            company: _company, user: state.userModel),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, $name",
                            style: TextStyle(
                                color: colorPrimary,
                                letterSpacing: 0,
                                fontSize: size.width <= 600 ? 20 : 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "home_text4".tr() + " !",
                              style: TextStyle(
                                color: Colors.grey,
                                letterSpacing: 0,
                                fontSize: size.width <= 600 ? 12 : 14,
                              ),
                            ),
                          ),
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
                                            fit: BoxFit.fitWidth,
                                            image: state.userModel.imgUrl ==
                                                        null ||
                                                    state.userModel.imgUrl == ""
                                                ? Image.asset(
                                                        "assets/images/ava.png")
                                                    .image
                                                : NetworkImage(
                                                    "https://api-zukses.yokesen.com/${state.userModel.imgUrl}"))))
                              ],
                            )),
                      ],
                    )
                  ]),
            ),
          );
        } else if (state is UserDataStateFailLoad) {
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
          );
        } else if (state is UserDataStateUpdateSuccess) {
          getUserProfile();
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
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data Error",
                    style: TextStyle(
                      color: colorPrimary,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width <= 600 ? 20 : 24,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "home_text4".tr() + " !",
                      style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 0,
                        fontSize: size.width <= 600 ? 12 : 14,
                      ),
                    ),
                  ),
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
                                image: Image.asset("assets/images/ava.png")
                                    .image)))
                  ],
                ))
          ]),
        );
      },
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
              "home_text6".tr(),
              style: TextStyle(
                  color: colorPrimary,
                  letterSpacing: 0,
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
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          primary: colorBackground,
                        ),
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
                "home_text10".tr(),
                style: TextStyle(
                    color: colorPrimary,
                    letterSpacing: 0,
                    fontSize: size.width <= 600 ? 18 : 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
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
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          primary: colorBackground,
                        ),
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
                            Text("home_text9".tr(args: ["Task"]),
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
    return new CupertinoAlertDialog(
      title: new Text(
        "Clock Out " + "success_text".tr() + " !",
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
            "Ahome_text13".tr(),
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
              title: "home_text14".tr(),
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
                "home_text15".tr(),
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

                          print("Time Overtime:" + timeOvertime);
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
                      hintText: 'home_text16'.tr(),
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
                      hintText: 'home_text17'.tr(),
                      hintStyle: TextStyle(fontSize: 14, color: colorNeutral2)),
                ),
              ),
              SizedBox(height: 10),
              LongButton(
                size: size,
                bgColor: colorPrimary,
                textColor: colorBackground,
                title: "home_text14".tr(),
                onClick: () {
                  if (textProjectOvertime.text != "" &&
                      textReasonOvertime.text != "") {
                    //timeCalculation(1);
                    setState(() {
                      dialogText = "Clock Out";
                    });

                    BlocProvider.of<OvertimeBloc>(context).add(AddOvertimeEvent(
                        date: DateTime.now(),
                        startTime: "18:00:00",
                        endTime: timeOvertime,
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
    return new CupertinoAlertDialog(
      title: new Text(
        "home_text18".tr(),
      ),
      content: new Text("home_text19").tr(),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("no_text".tr(), style: TextStyle(color: colorError)),
            onPressed: () {
              Navigator.pop(context);
            }),
        CupertinoDialogAction(
            child: Text(
              "yes_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
              clockOut();
            }),
      ],
    );
  }

  Widget _listViewMeeting(List<ScheduleModel> data, Size size) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: BoxDecoration(
            color: colorBackground, boxShadow: [boxShadowStandard]),
        child: Column(
          children: [
            data.length > 0
                ? data.length > 1
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(1.0),
                        itemCount: taskName.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListViewBox(
                            title: data[index].title,
                            detail: util.hourFormat(data[index].date) +
                                " - " +
                                util.hourFormat(data[index].meetingEndTime),
                            viewType: "meeting",
                          );
                        },
                      )
                    : ListViewBox(
                        title: data[0].title,
                        detail: util.hourFormat(data[0].date) +
                            " - " +
                            util.hourFormat(data[0].meetingEndTime),
                        viewType: "meeting",
                      )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: colorBorder))),
                        height: 40,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text("No Meeting Today.",
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontSize: size.height < 569 ? 12 : 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ))),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        backgroundColor: colorBackground),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenTab(index: 3)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("home_text9".tr(args: ["Meeting"]),
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
        ));
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

  Widget scrollInvitation(
      BuildContext context, Size size, TeamDetailModel model) {
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
            builder: (BuildContext context, myscrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            color: colorBackground,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                            onTap: () {
                              _controller.reverse();
                            },
                            child: FaIcon(FontAwesomeIcons.times,
                                color: colorPrimary,
                                size: size.height < 569 ? 20 : 25)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height < 569 ? 3 : 5,
                  ),
                  TitleFormat(
                    size: size,
                    title: "invite_confirm_text1".tr(),
                    detail: "invite_confirm_text2".tr(args: [model.teamName]),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  LongButton(
                    size: size,
                    title: "confirm_text".tr(),
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    onClick: () {
                      loginTeam();
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
