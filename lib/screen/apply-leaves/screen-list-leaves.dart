import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/API/overtime-services.dart';

import 'package:zukses_app_1/bloc/leaves/leave-bloc.dart';
import 'package:zukses_app_1/bloc/leaves/leave-event.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/screen/apply-leaves/add-apply-leaves.dart';
import 'package:zukses_app_1/constant/constant.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-tab-leaves.dart';

class ScreenListLeaves extends StatefulWidget {
  ScreenListLeaves({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenListLeaves createState() => _ScreenListLeaves();
}

class _ScreenListLeaves extends State<ScreenListLeaves>
    with SingleTickerProviderStateMixin {
  var leavesTitle = ["Schedule 1", "SChedule 2", "Schedule 3", "Schedule 4"];
  var leavesDate = [
    "14 Jan 2021 - 19 Jan 2021",
    "25 Jan 2021 - 31 Jan 2021",
    "4 Mar 2021- 6 Mar 2021",
    "9 Apr 2021 - 10 Apr 2021"
  ];
  TabController tabController;
  var status = [0, 1, 2, 1];
  var statusString = [];
  //0=> pending, 1 => accepted , 2 => Rejected
  int activeIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {});
  }

  _getTabIndex() {
    activeIndex = tabController.index;
    print(activeIndex);
  }

  void debug() {
    OvertimeServiceHTTP().fetchOvertime();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debug();
          },
        ),
        appBar: customAppBar(context,
            size: size,
            leadingIcon: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: colorPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: "Permission",
            actionList: [
              IconButton(
                padding: EdgeInsets.only(right: 20),
                splashColor: Colors.transparent,
                icon: FaIcon(
                  FontAwesomeIcons.plusCircle,
                  color: colorPrimary,
                  size: size.height < 570 ? 18 : 23,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ApplyLeavesFormScreen()));
                },
              ),
            ]),
        body: DefaultTabController(
            length: 2,
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
                          child: Center(
                            child: Text("Leaves"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Center(
                            child: Text("Overtime"),
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
                    tab: "leaves",
                  ),
                  ScreenTabLeaves(tab: "overtime")
                ],
              ),
            )));
  }
}
