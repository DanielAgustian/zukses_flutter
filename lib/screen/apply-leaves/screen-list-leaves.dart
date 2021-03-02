import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/screen/apply-leaves/add-apply-leaves.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/leaves/list-leaves.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScreenListLeaves extends StatefulWidget {
  ScreenListLeaves({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ScreenListLeaves createState() => _ScreenListLeaves();
}

class _ScreenListLeaves extends State<ScreenListLeaves> {
  var leavesTitle = ["Schedule 1", "SChedule 2", "Schedule 3", "Schedule 4"];
  var leavesDate = [
    "14 Jan 2021 - 19 Jan 2021",
    "25 Jan 2021 - 31 Jan 2021",
    "4 Mar 2021- 6 Mar 2021",
    "9 Apr 2021 - 10 Apr 2021"
  ];
  var status = [0, 1, 2, 1];
  var statusString = [];
  //0=> pending, 1 => accepted , 2 => Rejected
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            title: "Leaves",
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
        body: LayoutBuilder(builder: (ctx, constrains) {
          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: ListView.builder(
                    itemCount: leavesTitle.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListLeavesInside(
                          title: leavesTitle[index],
                          detail: leavesDate[index],
                          status: status[index]);
                    },
                  ),
                )
              ])),
            ),
          ]);
        }));
  }
}
