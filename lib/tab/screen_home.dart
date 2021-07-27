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
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/avatar/avatar-medium.dart';
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
import 'package:zukses_app_1/screen/contact-supervisor/screen-notification-list.dart';
import 'package:zukses_app_1/screen/profile/user-settings.dart';
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

  String statusOvertime = "";
  String key = "clock in";
  String teamId = "";

  //For Disabling Button ============================//
  DateTime now = DateTime.now();
  bool instruction = false;

  Util util = Util();

// Dummy data
  var skeleton = [1, 2];
  var enumTap = ["home_text1".tr(), "home_text3".tr(), "home_text2".tr()];

  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;

  bool changeTime = false;

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  DateTime backbuttonpressedTime;

  String tokenFCM = "";
  String companyID = "";

  @override
  void initState() {
    super.initState();
    // getMember();
    // getCompanyProfile();
    sharedPrefInstruction();
    // getUserProfile();
    // _getTaskLowPriority();
    // _getTaskHighPriority();
    // checkStatusClock();
    // _getMeetingToday();
    // _getMeetingRequest();
    // _getNotifAll();
    _controller = AnimationController(vsync: this, duration: _duration);
    Util().initDynamicLinks(context);

    if (widget.link != null) {
      teamId = widget.link.queryParameters['teamId'];
      _controller.forward();
      _getTeamDetail(teamId);
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
        child: RefreshIndicator(
          backgroundColor: colorPrimary70,
          color: colorBackground,
          strokeWidth: 1,
          onRefresh: refreshData,
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [realComponent(context, size)],
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
      ),
    );
  }

  Widget realComponent(BuildContext context, Size size) {
    AuthModel authModel;
    int companyAcceptance;
    String companyID;
    CompanyModel company;

    return BlocBuilder<CompanyBloc, CompanyState>(
      builder: (context, state) {
        if (state is CompanyStateSuccessLoad) {
          company = state.company;
        }
        return Column(
          children: [
            buildTapPresence(size,
                company: company,
                authModel: authModel,
                companyAcceptance: companyAcceptance,
                companyID: companyID),

            SizedBox(
              height: 10,
            ),
            //======================BlocBuilder Profile User===========================
            buildHeaderProfile(size, company: company),

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

            buildCounterBoxTask(size),
            SizedBox(
              height: 15,
            ),
            buildTaskList(size, context),
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
            buildCounterBoxMeeting(size),
            SizedBox(
              height: 15,
            ),
            buildMeetingList(size),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  Widget buildCounterBoxMeeting(Size size) {
    bool reqLoading = true;
    bool meetLoading = true;
    int meetCounter = 0;
    int reqCounter = 0;

    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<MeetingBloc, MeetingState>(
              builder: (context, state) {
                if (state is MeetingStateSuccessLoad) {
                  meetLoading = false;
                  meetCounter = state.meetings.length;
                } else if (state is MeetingStateLoading) {
                  meetLoading = true;
                } else {
                  meetLoading = false;
                }
                return BoxHome(
                    loading: meetLoading,
                    title: "home_text11".tr(),
                    total: meetCounter,
                    numberColor: colorSecondaryRed,
                    fontSize: size.width <= 600 ? 34 : 36);
              },
            ),
            BlocBuilder<MeetingReqBloc, MeetingReqState>(
              builder: (context, state) {
                if (state is MeetingReqStateSuccessLoad) {
                  reqLoading = false;
                  reqCounter = state.schedule.length;
                } else if (state is MeetingReqStateLoading) {
                  reqLoading = true;
                } else {
                  reqLoading = false;
                }

                return BoxHome(
                    loading: reqLoading,
                    title: "home_text12".tr(),
                    total: reqCounter,
                    numberColor: colorSecondaryYellow,
                    fontSize: size.width <= 600 ? 34 : 36);
              },
            )
          ],
        ));
  }

  Widget buildTaskList(Size size, BuildContext context) {
    List<TaskModel> tasks;
    bool loading = true;

    return BlocBuilder<TaskPriorityBloc, TaskPriorityState>(
      builder: (context, state) {
        if (state is TaskPriorityStateSuccessLoad) {
          loading = false;
          tasks =
              state.task.length < 2 ? state.task : state.task.take(2).toList();
        } else if (state is TaskPriorityStateFailLoad) {
          loading = false;
          tasks = [];
        }

        return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: colorBackground, boxShadow: [boxShadowStandard]),
            child: Column(
              children: [
                // List Builder for Task List
                if (loading)
                  ...skeleton.map((item) => SkeletonLess3(
                        size: size,
                        row: 2,
                        col: 1,
                      ))
                else
                  tasks == null || tasks.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: colorBorder))),
                              height: 40,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text("home_text20".tr(args: ["Task"]),
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontSize: size.height < 569 ? 14 : 16,
                                      )),
                                ),
                              )))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(1.0),
                          itemCount: tasks.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListViewBox(
                              title: tasks[index].taskName,
                              detail: tasks[index].details,
                              viewType: "task",
                            );
                          },
                        ),

                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            primary: colorBackground),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenTab(index: 2)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("home_text9".tr(args: ["Task"]),
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
      },
    );
  }

  Widget buildCounterBoxTask(Size size) {
    int highPriorityCount = 0;
    int lowPriorityCount = 0;
    bool highLoading = true;
    bool lowLoading = true;

    return Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<TaskPriorityBloc, TaskPriorityState>(
              builder: (context, state) {
                if (state is TaskPriorityStateSuccessLoad) {
                  highPriorityCount = state.task.length;
                  highLoading = false;

                  return BoxHome(
                    loading: highLoading,
                    title: "home_text7".tr(),
                    total: highPriorityCount,
                    numberColor: colorSecondaryRed,
                    fontSize: size.width <= 600 ? 34 : 36,
                  );
                } else if (state is TaskPriorityStateLoading) {
                  highLoading = true;
                } else {
                  highLoading = false;
                }
                return BoxHome(
                  loading: highLoading,
                  title: "home_text7".tr(),
                  total: highPriorityCount,
                  numberColor: colorSecondaryRed,
                  fontSize: size.width <= 600 ? 34 : 36,
                );
              },
            ),
            BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
              if (state is TaskStateSuccessLoad) {
                lowPriorityCount = state.task.length;
                lowLoading = false;
              } else if (state is TaskStateLoading) {
                lowLoading = true;
              } else {
                lowLoading = false;
              }
              return BoxHome(
                  loading: lowLoading,
                  title: "home_text8".tr(),
                  total: lowPriorityCount,
                  numberColor: colorClear,
                  fontSize: size.width <= 600 ? 34 : 36);
            }),
          ],
        ));
  }

  // Widget to tap clock in or clock out
  Widget buildTapPresence(Size size,
      {@required AuthModel authModel,
      @required int companyAcceptance,
      @required String companyID,
      @required CompanyModel company}) {
    bool loading = true;
    String stringTap = "home_text1".tr();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthStateFailLoad) {
        loading = false;
        Util().showToast(
            context: context,
            msg: "Authentication Failed!",
            duration: 3,
            color: colorError,
            txtColor: colorBackground);
      } else if (state is AuthStateSuccessLoad) {
        loading = false;
        authModel = state.authUser;
        // handle to get company acceptance after register
        companyAcceptance = authModel.user.companyAcceptance;
        companyID = authModel.user.companyID;

        //This function is for employee not yet accepted.
        pushToWaitRegis(
            companyAcceptance: companyAcceptance, companyID: companyID);

        if (authModel.maxClockIn == "false") {
          //if they arent clockout today
          if (authModel.attendance == "true") {
            // if they already clock in.
            stringTap = enumTap[1];
          }
        } else if (authModel.maxClockIn == "true") {
          //If they already clock out for today
          stringTap = enumTap[2];
        }
        // doneLoading();
      } else if (state is AuthStateSuccessTeamLoad) {
        loading = false;
        _controller.reverse();
      }

      return BlocConsumer<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceStateSuccessClockIn) {
            //if they already clock in
            authModel.maxClockIn = "false";
            authModel.attendance = "true";
            stringTap = enumTap[1];
          } else if (state is AttendanceStateSuccessClockOut) {
            //if they already clock out
            stringTap = enumTap[2];
            authModel.maxClockIn = "true";
          }

          return InkWell(
            onTap: () {
              onClickWatch(size,
                  company: company,
                  companyAcceptance: companyAcceptance,
                  authModel: authModel);
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
                      loading
                          ? SkeletonAnimation(
                              shimmerColor: colorNeutral170,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorSkeleton,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: size.width * 0.4,
                                height: 20,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: companyAcceptance == 1
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/tap-clock-in.svg",
                                            width: size.height < 569 ? 20 : 25,
                                            height:
                                                size.height < 569 ? 20 : 25),
                                        // SizedBox(width: 10),
                                        Text(
                                          stringTap,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: colorPrimary,
                                              fontSize:
                                                  size.height < 600 ? 14 : 16),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Welcome to Zukses!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: colorPrimary,
                                                fontSize: size.height < 600
                                                    ? 14
                                                    : 16),
                                          ),
                                        )
                                      ],
                                    ))
                    ]))),
          );
        },
        listener: (context, state) {
          if (state is AttendanceStateFailed) {
            Util().showToast(
                context: this.context,
                msg: "Something Wrong !",
                color: colorError,
                txtColor: colorBackground);
          } else if (state is AttendanceStateSuccessClockIn) {
            //if they already clock in
            // stringTap = enumTap[1];
          } else if (state is AttendanceStateSuccessClockOut) {
            //if they already clock out
            // stringTap = enumTap[2];
            // authModel.maxClockIn = "true";

            // show confirm dialog success clock out
            showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "_BlocListener"))
                .then((value) => stringTap = enumTap[2]);
          }
          print(stringTap);
        },
      );
    });
  }

  // build widget to show team
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
                                value: "https://api-zukses.yokesen.com/" +
                                    state.team[index].imgUrl,
                                status: state.team[index].late,
                              )
                            : UserAvatar(
                                dotSize: 7, status: state.team[index].late),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is TeamStateLoading) {
            return Container(
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
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // Widget to show the profile
  Widget buildHeaderProfile(Size size, {@required CompanyModel company}) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataStateSuccessLoad) {
          String name =
              state.userModel.name == null ? "Username" : state.userModel.name;
          if (name.length > 15) {
            var parts = name.split(" ");
            name = parts[0];
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (company != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfile(
                                  company: company, user: state.userModel),
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
                    child: Container(
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
                  ),
                  Row(
                    children: [
                      BlocBuilder<NotifAllBloc, NotifAllState>(
                          builder: (context, state) {
                        if (state is NotifAllStateSuccessLoad) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ScreenNotificationList(),
                                  ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: FaIcon(
                                    FontAwesomeIcons.solidBell,
                                    size: size.height < 569 ? 18 : 25,
                                    color: colorPrimary,
                                  ),
                                ),
                                badgeNotification(count: state.models.length)
                              ],
                            ),
                          );
                        } else if (state is NotifAllStateFailed) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ScreenNotificationList(),
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: FaIcon(
                                FontAwesomeIcons.solidBell,
                                size: size.height < 569 ? 18 : 25,
                                color: colorPrimary,
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                      SizedBox(
                        width: size.height < 569 ? 10 : 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (company != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                      company: company, user: state.userModel),
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
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AvatarMedium(
                                  imgUrl:
                                      "https://api-zukses.yokesen.com/${state.userModel.imgUrl}",
                                ),
                              ],
                            )),
                      ),
                    ],
                  )
                ]),
          );
        } else if (state is UserDataStateUpdateSuccess) {
          getUserProfile();
        } else {
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

//Widget untuk Popup Dialog.
  Widget _buildPopupDialog(BuildContext context, String where) {
    return new CupertinoAlertDialog(
      title: new Text(
        "Clock out " + "success_text".tr() + " !",
      ),
      content: new Text("Clock out in " + getSystemTime()),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  //Widget untuk clock out sebelum waktunya.
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

  Widget buildMeetingList(Size size) {
    List<ScheduleModel> meetings;
    bool loading = true;

    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state is MeetingStateSuccessLoad) {
          loading = false;
          if (state.meetings == null || state.meetings.length == 0) {
            meetings = state.meetings;
          } else {
            meetings = state.meetings
                .where((element) =>
                    util.yearFormat(now) == util.yearFormat(element.date))
                .take(2)
                .toList();
          }
        } else if (state is MeetingStateLoading) {
          loading = true;
        } else {
          loading = false;
        }
        return Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: colorBackground, boxShadow: [boxShadowStandard]),
            child: Column(
              children: [
                if (loading)
                  ...skeleton.map((item) => SkeletonLess3(
                        size: size,
                        row: 2,
                        col: 1,
                      ))
                else
                  meetings == null || meetings.length == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: colorBorder))),
                              height: 40,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                      "home_text20".tr(args: ["Meeting"]),
                                      style: TextStyle(
                                        color: colorPrimary,
                                        fontSize: size.height < 569 ? 14 : 16,
                                      )),
                                ),
                              )))
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(1.0),
                          itemCount: meetings.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListViewBox(
                              title: meetings[index].title,
                              detail: util.hourFormat(meetings[index].date) +
                                  " - " +
                                  util.hourFormat(
                                      meetings[index].meetingEndTime),
                              viewType: "meeting",
                            );
                          },
                        ),
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
      },
    );
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

  //---------------------Function Logic----------------------------//

  Future<void> refreshData() async {
    getMember();
    getCompanyProfile();
    sharedPrefInstruction();
    getUserProfile();
    _getTaskLowPriority();
    _getTaskHighPriority();
    _getMeetingToday();
    _getMeetingRequest();
    _getNotifAll();
    checkStatusClock();
  }

  void doneLoading() {
    setState(() {
      isLoading = false;
    });
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

  void checkStatusClock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var googleSign = prefs.getInt('google');
    var facebookSign = prefs.getInt('facebook');
    String tokenFCM = prefs.getString('fcmToken');

    if (googleSign != null) {
      getAuthGoogle(tokenFCM);
    } else if (facebookSign != null) {
      getAuthFacebook(tokenFCM);
    } else {
      getAuthData(tokenFCM);
    }
  }

  void getAuthData(String tokenFCM) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    // print("username " + username);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginManual(
        email: username, password: password, tokenFCM: tokenFCM));
  }

  void getAuthGoogle(String tokenFCM) async {
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

  void getAuthFacebook(String tokenFCM) async {
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
    BlocProvider.of<MeetingBloc>(context)
        .add(GetAcceptedMeetingEvent(month: now.month, year: now.year));
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

  void _getNotifAll() async {
    BlocProvider.of<NotifAllBloc>(context).add(GetNotifForAllEvent());
  }

  pushToWaitRegis(
      {@required String companyID, @required int companyAcceptance}) async {
    if (companyID != "" && companyAcceptance == 0) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WaitRegisApproved()),
          (route) => false);
    }
  }

  //Fungsi untuk Click di Jam.
  void onClickWatch(Size size,
      {@required int companyAcceptance,
      @required AuthModel authModel,
      @required CompanyModel company}) {
    if (companyAcceptance == 1) {
      if (authModel.maxClockIn != null && authModel.attendance != null) {
        if (authModel.maxClockIn == "false") {
          if (authModel.attendance == "false") {
            if (instruction == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CameraNonInstruction()));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraInstruction()),
              );
            }
          } else if (authModel.attendance == "true") {
            //Clock Out
            int diff = timeCalculation(company.endOfficeTime);
            //if employee clock out before office closing time
            if (diff < 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildClockOutNotFinished(context, size));
            } else {
              clockOut();
            }
          }
        }
      }
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

  String formatOfficeTime(String tod) {
    TimeOfDay timeTemp = Util().stringToTimeOfDay(tod);
    return Util().changeTimeToString(timeTemp);
  }

  int timeCalculation(String endOfficeString) {
    TimeOfDay now = TimeOfDay.now();
    if (endOfficeString != null) {
      TimeOfDay endOfficeTime = Util().stringToTimeOfDay(endOfficeString);
      int diffHour = ((now.hour * 60) + now.minute) -
          ((endOfficeTime.hour * 60) + endOfficeTime.minute);
      return diffHour;
    } else {
      return 86400;
    }
  }

  Widget badgeNotification({int count}) {
    if (count < 1) {
      return Positioned(right: 0, top: 0, child: Container());
    }
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: colorError,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text("$count",
            style: TextStyle(color: colorBackground, fontSize: 10)),
      ),
    );
  }
}
