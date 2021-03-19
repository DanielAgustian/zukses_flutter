import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-bloc.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-event.dart';
import 'package:zukses_app_1/bloc/meeting/meeting-state.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/util/util.dart';

class ScheduleItemRequest extends StatelessWidget {
  const ScheduleItemRequest(
      {Key key,
      @required this.size,
      this.title,
      this.time1,
      this.time2,
      this.onClick,
      this.date,
      this.meetingId,
      this.count})
      : super(key: key);

  final Size size;
  final String title, meetingId;
  final String time1, time2, date;
  final Function onClick;
  final int count;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorBackground,
              boxShadow: [
                BoxShadow(
                  color: colorNeutral1.withOpacity(1),
                  blurRadius: 15,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                    color: colorPrimary,
                  )),
              SizedBox(
                height: 5,
              ),
              Text(date,
                  style: TextStyle(
                    fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                    color: colorPrimary50,
                  )),
              Text('$time1 - $time2',
                  style: TextStyle(
                    fontSize: size.height <= 569 ? textSizeSmall14 : 16,
                    color: colorPrimary50,
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return UserAvatar();
                    },
                  ))
            ],
          ),
        ),
        secondaryActions: [
          IconSlideAction(
              iconWidget: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorSecondaryRed),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.white,
                  ),
                ),
              ),
              color: colorBackground,
              onTap: () {
                print("Delete");
                showDialog(
                    context: context,
                    builder: (context) =>
                        _buildPopupClockOut(context, size: size));
              }),
        ],
      ),
    );
  }

  void deleteData(BuildContext context) {
    BlocProvider.of<MeetingBloc>(context)
        .add(DeleteMeetingEvent(meetingID: meetingId));
  }

  Widget _buildPopupClockOut(BuildContext context, {size}) {
    return BlocListener<MeetingBloc, MeetingState>(
        listener: (context, state) {
          if (state is MeetingStateSuccess) {
            Util().showToast(
                context: context,
                msg: "Data has been deleted",
                duration: 3,
                txtColor: colorPrimary,
                color: colorNeutral1);
            return Container();
          } else {
            Util().showToast(
                context: context,
                msg: "Failed to be Deleted",
                duration: 3,
                txtColor: colorError,
                color: colorNeutral1);
            return Container();
          }
        },
        child: new AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Are you sure to delete this schedule ?",
                style: TextStyle(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              LongButton(
                size: size,
                bgColor: colorPrimary,
                textColor: colorBackground,
                title: "Yes ",
                onClick: () {
                  //LOGIC
                  print(meetingId);
                  deleteData(context);
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
              LongButtonOutline(
                size: size,
                bgColor: colorBackground,
                textColor: colorPrimary,
                outlineColor: colorPrimary,
                title: "No",
                onClick: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
