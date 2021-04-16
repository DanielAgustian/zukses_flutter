import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/tab/screen_task.dart';
import 'package:zukses_app_1/tab/screen_home.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/tab/screen_meeting.dart';
import 'package:zukses_app_1/tab/screen_attendance.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenTab extends StatefulWidget {
  ScreenTab({Key key, this.title, this.index, this.link}) : super(key: key);
  final String title;
  final int index;
  final Uri link;
  @override
  _ScreenTab createState() => _ScreenTab();
}

class _ScreenTab extends State<ScreenTab> {
  List<Widget> screenList = [];
  int _currentScreenIndex;
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != null) {
      _currentScreenIndex = widget.index;
    } else {
      _currentScreenIndex = 0;
    }

    screenList.add(HomeScreen());
    screenList.add(AttendanceScreen());
    /*screenList.add(Container(
      child: Center(child: Text("Under Development.")),
    ));
    screenList.add(Container(
      child: Center(child: Text("Under Development.")),
    ));*/
    screenList.add(TaskScreen());
    screenList.add(MeetingScreen());
    Util util = Util();
    util.initDynamicLinks(context);
    
  }

  void onTabTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: screenList[_currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex:
            _currentScreenIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/home.png'))
            /*new Icon(
              Icons.home_filled,
              size: 27,
            )*/
            ,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/attendance-icon.png')),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.clipboardList), label: 'Task'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidCalendar), label: 'Schedule'),
        ],
        unselectedFontSize: 12,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        selectedItemColor: Color.fromRGBO(20, 43, 111, 0.9),
        unselectedItemColor: colorPrimary70,
        selectedIconTheme: IconThemeData(color: colorPrimary),
        unselectedIconTheme: IconThemeData(color: colorPrimary70),
      ),
    );
  }

  /*Widget scrollInvitation(BuildContext context, Size size) {
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
            builder: (BuildContext context, myscrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            color: Color(0xFFFFFFFF),
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
                    height: size.height < 569 ? 5 : 10,
                  ),
                  TitleFormat(
                    size: size,
                    title: "Team Invitation",
                    detail:
                        "You are invited to “Tech Squad” team. Please confirm to join the team.",
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  LongButton(
                    size: size,
                    title: "Confirm",
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    onClick: () {},
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }*/ 
}
