import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/leaves/list-leaves.dart';

class ScreenTabLeaves extends StatefulWidget {
  const ScreenTabLeaves({Key key, this.tab}) : super(key: key);

  @override
  _ScreenTabLeavesState createState() => _ScreenTabLeavesState();

  final String tab;
}

class _ScreenTabLeavesState extends State<ScreenTabLeaves> {
  var leavesTitle = ["Schedule 1", "SChedule 2", "Schedule 3", "Schedule 4"];
  var leavesDate = [
    "14 Jan 2021 - 19 Jan 2021",
    "25 Jan 2021 - 31 Jan 2021",
    "4 Mar 2021- 6 Mar 2021",
    "9 Apr 2021 - 10 Apr 2021"
  ];
  var status = [0, 1, 2, 1];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.tab == "leaves"
        ? LayoutBuilder(builder: (ctx, constrains) {
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: leavesTitle.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListLeavesInside(
                        screen: widget.tab,
                        title: leavesTitle[index],
                        detail: leavesDate[index],
                        status: status[index]);
                  },
                ),
              ),
            ]);
          })
        : LayoutBuilder(builder: (ctx, constrains) {
            return Column(children: [
              Expanded(
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
              ),
            ]);
          });
  }
}
