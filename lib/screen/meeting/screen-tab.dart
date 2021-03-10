import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/button/button-small-outlined.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/schedule/schedule-item.dart';
import 'package:zukses_app_1/component/schedule/user-assigned-item.dart';
import 'package:zukses_app_1/component/schedule/user-invitation-item.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';
import 'package:zukses_app_1/constant/constant.dart';

class ScreenTabRequest extends StatefulWidget {
  const ScreenTabRequest({Key key, this.screen, this.loading = true})
      : super(key: key);

  @override
  _ScreenTabRequestState createState() => _ScreenTabRequestState();

  final String screen;
  final bool loading;
}

class _ScreenTabRequestState extends State<ScreenTabRequest>
    with SingleTickerProviderStateMixin {
  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            child: widget.loading
                ? ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => SkeletonLess3WithAvatar(
                          size: size,
                          row: 2,
                        ))
                : ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => ScheduleItem(
                        size: size,
                        onClick: () {
                          if (_controller.isDismissed)
                            _controller.forward();
                          else if (_controller.isCompleted)
                            _controller.reverse();
                        },
                        time1: "08.00",
                        time2: "09.00",
                        title: "Schedule title"))),
        scrollerSheet()
      ],
    );
  }

  Widget scrollerSheet() {
    bool temp = false;
    Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
          maxChildSize: 0.9,
          initialChildSize: 0.8,
          minChildSize: 0.8,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 15)],
                  color: colorBackground,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule Title",
                    style: TextStyle(
                        fontSize: 20,
                        color: colorPrimary,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("08.00-09.00",
                      style: TextStyle(
                        fontSize: 16,
                        color: colorNeutral2,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, ",
                    style: TextStyle(
                        fontSize: 14,
                        color: colorPrimary,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Assigned To",
                      style: TextStyle(
                          fontSize: 16,
                          color: colorPrimary,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return UserAssignedItem(
                            size: size, index: index, status: "Success");
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  LongButton(
                    size: size,
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    title: "Accept",
                    onClick: () {},
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  LongButtonOutline(
                    outlineColor: colorError,
                    size: size,
                    bgColor: colorBackground,
                    textColor: colorError,
                    title: "Reject",
                    onClick: () {
                      _controller.reverse();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _dialog(context));
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      //title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Why are you rejecting the meeting?",
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
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
              //controller: textReasonOvertime,
              keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 6,
              decoration: new InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Reason..',
                  hintStyle: TextStyle(fontSize: 14, color: colorNeutral2)),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SmallButton(
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                  title: "Cancel",
                  onClick: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                SmallButtonOutlined(
                  bgColor: colorBackground,
                  textColor: colorPrimary,
                  borderColor: colorPrimary,
                  title: "Confirm",
                  onClick: () {},
                ),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[],
    );
  }
}
