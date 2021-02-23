import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textTitle = new TextEditingController();
  TextEditingController textSearch = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  bool _titleValidator = false;
  bool _descriptionValidator = false;
  DateTime date = DateTime.now();

  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  void showConfirmDismiss({size}) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.5),
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Text(
                      "Are you sure you want to discard your changes ?",
                      style: TextStyle(color: colorPrimary, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LongButton(
                    size: size,
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    title: "Keep Editing",
                    onClick: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  LongButtonOutline(
                    outlineColor: colorError,
                    size: size,
                    bgColor: colorBackground,
                    textColor: colorError,
                    title: "Discard Changes",
                    onClick: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<bool> _onWillPop({size}) async {
    return (await showDialog(
            context: context,
            barrierColor: Colors.white.withOpacity(0.5),
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          "Are you sure you want to discard your changes ?",
                          style: TextStyle(color: colorPrimary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButton(
                        size: size,
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        title: "Keep Editing",
                        onClick: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LongButtonOutline(
                        outlineColor: colorError,
                        size: size,
                        bgColor: colorBackground,
                        textColor: colorError,
                        title: "Discard Changes",
                        onClick: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              );
            })) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if (textDescription.text != "" || textTitle.text != "")
          return _onWillPop(size: size);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorPrimary,
            ),
            onPressed: () {
              if (textDescription.text != "" || textTitle.text != "")
                showConfirmDismiss(size: size);
              else
                Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "Add Schedule",
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 20 : 25),
          ),
          actions: [
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: size.height <= 569 ? 15 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: colorBackground,
        body: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: colorBackground,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: _titleValidator
                                ? Border.all(color: colorError)
                                : Border.all(color: Colors.transparent),
                            color: colorBackground,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Color.fromRGBO(240, 239, 242, 1),
                                  blurRadius: 15),
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.streetAddress,
                          onChanged: (val) {},
                          controller: textTitle,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              hintText: "Title",
                              hintStyle: TextStyle(
                                color: _titleValidator
                                    ? colorError
                                    : colorNeutral1,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: _descriptionValidator
                                ? Border.all(color: colorError)
                                : Border.all(color: Colors.transparent),
                            color: colorBackground,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: Color.fromRGBO(240, 239, 242, 1),
                                  blurRadius: 15),
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          maxLines: 8,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {},
                          controller: textDescription,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              hintText: "Description",
                              hintStyle: TextStyle(
                                color: _descriptionValidator
                                    ? colorError
                                    : colorNeutral1,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AddScheduleRow(
                        fontSize: size.height <= 569 ? 14 : 16,
                        title: "Date",
                        textItem: "${formater.format(date)}",
                      ),
                      AddScheduleRow(
                        fontSize: size.height <= 569 ? 14 : 16,
                        title: "Time",
                        textItem: "09.00 - 09.30",
                      ),
                      AddScheduleRow(
                        fontSize: size.height <= 569 ? 14 : 16,
                        title: "Repeat",
                        textItem: "Never",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Invite",
                          style: TextStyle(
                              fontSize: size.height <= 569 ? 14 : 16,
                              color: colorPrimary),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButtonIcon(
                        size: size,
                        title: "Add Invitation",
                        bgColor: colorBackground,
                        textColor: colorPrimary,
                        iconWidget: FaIcon(
                          FontAwesomeIcons.plusCircle,
                          color: colorPrimary,
                        ),
                        onClick: () {
                          if (_controller.isDismissed)
                            _controller.forward();
                          else if (_controller.isCompleted)
                            _controller.reverse();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 8,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorSecondaryRed,
                                  radius: size.height <= 569 ? 20 : 30,
                                ),
                                Text(
                                  "Done",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorPrimary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox.expand(
                child: SlideTransition(
                  position: _tween.animate(_controller),
                  child: DraggableScrollableSheet(
                    maxChildSize: 0.8,
                    initialChildSize: 0.7,
                    minChildSize: 0.3,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(blurRadius: 15)],
                            color: colorBackground,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _controller.reverse();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 16, color: colorPrimary),
                                  ),
                                ),
                                Text(
                                  "Add Invitation",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: colorPrimary,
                                      fontWeight: FontWeight.w700),
                                ),
                                InkWell(
                                  onTap: () {
                                    _controller.reverse();
                                  },
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: colorPrimary,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              // height: 50,
                              decoration: BoxDecoration(
                                  color: colorBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        color: Color.fromRGBO(240, 239, 242, 1),
                                        blurRadius: 15),
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: (val) {},
                                controller: textSearch,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: colorNeutral1,
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                      color: colorNeutral1,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    colorSecondaryRed,
                                                radius: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Done",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: colorPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Checkbox(
                                              value: false,
                                              activeColor: colorClear,
                                              checkColor: Colors.white,
                                              onChanged: (value) {}),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
