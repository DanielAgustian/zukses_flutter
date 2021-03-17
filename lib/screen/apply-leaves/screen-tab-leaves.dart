import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/leaves/leave-bloc.dart';
import 'package:zukses_app_1/bloc/leaves/leave-event.dart';
import 'package:zukses_app_1/bloc/leaves/leave-state.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-bloc.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-event.dart';
import 'package:zukses_app_1/bloc/overtime/overtime-state.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<LeaveBloc>(context).add(LoadAllLeaveEvent());
    BlocProvider.of<OvertimeBloc>(context).add(LoadAllOvertimeEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.tab == "leaves"
        ? BlocBuilder<LeaveBloc, LeaveState>(builder: (context, state) {
            if (state is LeaveStateSuccessLoad) {
              return LayoutBuilder(builder: (ctx, constrains) {
                return Column(children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.leave.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListLeavesInside(
                            screen: widget.tab,
                            title: state.leave[index].typeName,
                            detail: state.leave[index].duration,
                            status: state.leave[index].status,
                            date: state.leave[index].leaveDate == null
                                ? "Data Cant Be fetch"
                                : state.leave[index].leaveDate);
                      },
                    ),
                  ),
                ]);
              });
            }
            return Container();
          })
        : BlocBuilder<OvertimeBloc, OvertimeState>(builder: (context, state) {
            if (state is OvertimeStateSuccessLoad) {
              return LayoutBuilder(builder: (ctx, constrains) {
                return Column(children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.overtime.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListLeavesInside(
                            title: state.overtime[index].project,
                            detail: state.overtime[index].clockOut.toString(),
                            status: state.overtime[index].status,
                            date: "1996-01-01");
                      },
                    ),
                  ),
                ]);
              });
            } else {
              return Container();
            }
          });

    /**/
  }
}
