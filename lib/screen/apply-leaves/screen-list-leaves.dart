import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/screen/apply-leaves/add-apply-leaves.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-tab-leaves.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenListLeaves extends StatefulWidget {
  ScreenListLeaves({Key key, this.title, this.permission, this.animate})
      : super(key: key);
  final bool animate;
  final String title;
  final String permission;
  @override
  _ScreenListLeaves createState() => _ScreenListLeaves();
}

class _ScreenListLeaves extends State<ScreenListLeaves>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<int> permissionTotal = [0, 0, 0];
  bool isLoading = true;
  var statusString = [];
  //0=> pending, 1 => accepted , 2 => Rejected
  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      _getTabIndex();
    });
    if (widget.animate != null) {
      tabController.animateTo(1);
    }
    if (widget.permission == "leaves") {
      BlocProvider.of<LeaveBloc>(context).add(LoadAllLeaveEvent());
    } else if (widget.permission == "overtime") {
      BlocProvider.of<OvertimeBloc>(context).add(LoadAllOvertimeEvent());
    }
  }

  _getTabIndex() {
    setState(() {
      activeIndex = tabController.index;
    });

    print(activeIndex);
  }

  _toAddLeaveOvertime() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ApplyLeavesFormScreen(permission: widget.permission)));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: customAppBar(context,
            size: size,
            leadingIcon: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: colorPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: widget.permission == "leaves"
                ? "leave_text".tr()
                : "overtime_text".tr(),
            actionList: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  padding: EdgeInsets.only(right: 20),
                  splashColor: Colors.transparent,
                  icon: FaIcon(
                    FontAwesomeIcons.plusCircle,
                    color: colorPrimary,
                    size: size.height < 570 ? 18 : 23,
                  ),
                  onPressed: () {
                    _toAddLeaveOvertime();
                  },
                ),
              ),
            ]),
        body: Stack(
          children: [
            widget.permission == "leaves"
                ? BlocListener<LeaveBloc, LeaveState>(
                    listener: (context, state) {
                      if (state is LeaveStateSuccessLoad) {
                        setState(() {
                          permissionTotal = [0, 0, 0];
                        });
                        state.leave.forEach((element) {
                          if (element.status.toLowerCase() == "accepted") {
                            setState(() {
                              permissionTotal[0] = permissionTotal[0] + 1;
                            });
                          } else if (element.status.toLowerCase() ==
                              "pending") {
                            setState(() {
                              permissionTotal[1] = permissionTotal[1] + 1;
                            });
                          } else if (element.status.toLowerCase() ==
                              "rejected") {
                            setState(() {
                              permissionTotal[2] = permissionTotal[2] + 1;
                            });
                          }
                        });
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(),
                  )
                : BlocListener<OvertimeBloc, OvertimeState>(
                    listener: (context, state) {
                      if (state is OvertimeStateSuccessLoad) {
                        setState(() {
                          permissionTotal = [0, 0, 0];
                        });
                        state.overtime.forEach((element) {
                          if (element.status.toLowerCase() == "accepted") {
                            setState(() {
                              permissionTotal[0] = permissionTotal[0] + 1;
                            });
                          } else if (element.status.toLowerCase() ==
                              "pending") {
                            setState(() {
                              permissionTotal[1] = permissionTotal[1] + 1;
                            });
                          } else if (element.status.toLowerCase() ==
                              "rejected") {
                            setState(() {
                              permissionTotal[2] = permissionTotal[2] + 1;
                            });
                          }
                        });
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(),
                  ),
            DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: colorBackground,
                  appBar: AppBar(
                    backgroundColor: colorBackground,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    flexibleSpace: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: colorNeutral150,
                          borderRadius: BorderRadius.circular(5)),
                      child: TabBar(
                        controller: tabController,
                        labelColor: colorBackground,
                        unselectedLabelColor: colorPrimary,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        indicator: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5)),
                        tabs: [
                          Tab(
                            child: Container(
                              child: Stack(
                                children: [
                                  
                                  positionedDot(
                                      context, size, permissionTotal[0])
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text("waiting_text").tr(),
                                  ),
                                  positionedDot(
                                      context, size, permissionTotal[1])
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text("rejected_text").tr(),
                                  ),
                                  positionedDot(
                                      context, size, permissionTotal[2])
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    controller: tabController,
                    children: [
                      ScreenTabLeaves(
                          permission: widget.permission, tab: "accepted"),
                      ScreenTabLeaves(
                          permission: widget.permission, tab: "pending"),
                      ScreenTabLeaves(
                          permission: widget.permission, tab: "rejected")
                    ],
                  ),
                )),
            isLoading
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black38.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: colorPrimary70,
                        // strokeWidth: 0,
                        valueColor: AlwaysStoppedAnimation(colorBackground),
                      ),
                    ),
                  )
                : Container()
          ],
        ));
  }

  Widget positionedDot(BuildContext context, Size size, int value) {
    return value < 1
        ? Container()
        : Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorSecondaryRed,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                        color: colorBackground,
                        fontSize: size.height < 569 ? 8 : 10),
                  ),
                ),
              ),
            ));
  }
}
