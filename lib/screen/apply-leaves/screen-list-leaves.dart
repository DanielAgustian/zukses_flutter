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
  ScreenListLeaves({Key key, this.title, this.permission}) : super(key: key);

  final String title;
  final String permission;
  @override
  _ScreenListLeaves createState() => _ScreenListLeaves();
}

class _ScreenListLeaves extends State<ScreenListLeaves>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  var status = [0, 1, 2, 1];
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
  }

  _getTabIndex() {
    setState(() {
      activeIndex = tabController.index;
    });

    print(activeIndex);
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
            title: widget.permission == "leaves" ? "Leaves" : "Overtime",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApplyLeavesFormScreen(
                                  index: activeIndex,
                                )));
                  },
                ),
              ),
            ]),
        body: DefaultTabController(
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
                          child: Center(
                            child: Text("Accepted"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Center(
                            child: Text("Waiting"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          child: Center(
                            child: Text("Rejected"),
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
                    permission: widget.permission,
                    tab: "accepted"
                  ),
                  ScreenTabLeaves(permission: widget.permission,
                  tab:"pending"),
                  ScreenTabLeaves(
                    permission: widget.permission,
                  tab:"rejected"
                  )
                ],
              ),
            )));
  }
}
