import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/leaves/list-leaves-overtime.dart';
import 'package:zukses_app_1/component/leaves/list-leaves.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/leave-model.dart';
import 'package:zukses_app_1/model/overtime-model.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-details.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenTabLeaves extends StatefulWidget {
  const ScreenTabLeaves({
    Key key,
    this.permission,
    this.tab,
  }) : super(key: key);

  @override
  _ScreenTabLeavesState createState() => _ScreenTabLeavesState();

  final String tab, permission;
}

class _ScreenTabLeavesState extends State<ScreenTabLeaves> {
  List<LeaveModel> listWaiting = [];
  List<LeaveModel> listAccepted = [];
  List<LeaveModel> listRejected = [];
  List<OvertimeModel> listWaitingOvertime = [];
  List<OvertimeModel> listAcceptedOvertime = [];
  List<OvertimeModel> listRejectedOvertime = [];
  bool isLoadingLeaves = false;
  bool isLoadingOvertime = false;

  @override
  void initState() {
    super.initState();
    if (widget.permission == "leaves") {
      BlocProvider.of<LeaveBloc>(context).add(LoadAllLeaveEvent());
    } else if (widget.permission == "overtime") {
      BlocProvider.of<OvertimeBloc>(context).add(LoadAllOvertimeEvent());
    }
    listWaiting.clear();
    listAccepted.clear();
    listRejected.clear();
  }

  void changeTimeStart() {}
  @override
  Widget build(BuildContext context) {
    return widget.permission == "leaves"
        ? Column(
            children: [
              BlocListener<LeaveBloc, LeaveState>(
                listener: (context, state) {
                  if (state is LeaveStateSuccessLoad) {
                    listAccepted.clear();
                    listWaiting.clear();
                    listRejected.clear();
                    for (int i = 0; i < state.leave.length; i++) {
                      if (state.leave[i].status == "accepted") {
                        listAccepted.add(state.leave[i]);
                      } else if (state.leave[i].status == "pending") {
                        listWaiting.add(state.leave[i]);
                      } else if (state.leave[i].status == "rejected") {
                        listRejected.add(state.leave[i]);
                      }
                    }
                    setState(() {
                      isLoadingLeaves = true;
                    });
                  }
                },
                child: Container(),
              ),
              isLoadingLeaves
                  ? widget.tab == "accepted"
                      ? printDataFilter(context, widget.tab, listAccepted)
                      : widget.tab == "pending"
                          ? printDataFilter(context, widget.tab, listWaiting)
                          : widget.tab == "rejected"
                              ? printDataFilter(
                                  context, widget.tab, listRejected)
                              : Container()
                  : Center(child: CircularProgressIndicator())
            ],
          )
        : Column(
            children: [
              BlocListener<OvertimeBloc, OvertimeState>(
                listener: (context, state) {
                  if (state is OvertimeStateSuccessLoad) {
                    listAcceptedOvertime.clear();
                    listRejectedOvertime.clear();
                    listWaitingOvertime.clear();
                    for (int i = 0; i < state.overtime.length; i++) {
                      if (state.overtime[i].status == "accepted") {
                        listAcceptedOvertime.add(state.overtime[i]);
                      } else if (state.overtime[i].status == "pending") {
                        listWaitingOvertime.add(state.overtime[i]);
                      } else if (state.overtime[i].status == "rejected") {
                        listRejectedOvertime.add(state.overtime[i]);
                      }
                    }
                    setState(() {
                      isLoadingOvertime = true;
                    });
                  }
                },
                child: Container(),
              ),
              isLoadingOvertime
                  ? widget.tab == "accepted"
                      ? _viewOvertime(context, widget.tab, listAcceptedOvertime)
                      : widget.tab == "pending"
                          ? _viewOvertime(
                              context, widget.tab, listWaitingOvertime)
                          : widget.tab == "rejected"
                              ? _viewOvertime(
                                  context, widget.tab, listRejectedOvertime)
                              : Container()
                  : Center(child: CircularProgressIndicator())
            ],
          );
    //_viewOvertime(context);

    /**/
  }

  //untuk viewOvertime
  Widget _viewOvertime(
      BuildContext context, String tab, List<OvertimeModel> list) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      flex: 1,
      child: list.length < 1
          ? Center(
              child: Text(
              "No Overtime has been " + tab,
              style: TextStyle(
                  fontSize: size.height < 569 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary),
            ))
          : ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeavesDetailScreen(
                                  details: "overtime",
                                  overtime: list[index],
                                )));
                  },
                  child: ListLeavesOvertime(
                    screen: widget.permission,
                    title: list[index].project,
                    detail: Util().cutTime(list[index].startTime) +
                        " - " +
                        Util().cutTime(list[index].endTime),
                    status: list[index].status,
                  ),
                );
              },
            ),
    );
  }

  //untuk view Leave
  Widget printDataFilter(
      BuildContext context, String tab, List<LeaveModel> list) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      flex: 1,
      child: list.length < 1
          ? Center(
              child: Text(
              "No $tab leaves at the moment",
              style: TextStyle(
                  fontSize: size.height < 569 ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: colorPrimary),
            ))
          : ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeavesDetailScreen(
                                  details: "leaves",
                                  leave: list[index],
                                )));
                  },
                  child: ListLeavesInside(
                      screen: widget.permission,
                      title: list[index].typeName,
                      detail: list[index].leaveDate == null
                          ? "apply_overtime_text8".tr()
                          : Util().dateNumbertoCalendar(
                              DateTime.parse(list[index].leaveDate)),
                      status: list[index].status,
                      time: list[index].startTime == null
                          ? ""
                          : Util().cutTime(list[index].startTime) +
                              "-" +
                              Util().cutTime(list[index].endTime)),
                );
              }),
    );
  }
}
