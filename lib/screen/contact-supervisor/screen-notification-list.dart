import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/bloc/notif-all/notif-all-bloc.dart';
import 'package:zukses_app_1/component/notification/notification-box.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/notif-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-answer-contact.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';

class ScreenNotificationList extends StatefulWidget {
  ScreenNotificationList();
  _ScreenNotificationList createState() => _ScreenNotificationList();
}

class _ScreenNotificationList extends State<ScreenNotificationList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotifAllBloc>(context).add(GetNotifForAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorBackground,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: colorPrimary,
              ))),
        ),
        title: Text(
          "notif_list_1".tr(),
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 16 : 18),
        ),
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: Center(
                child: Text(
                  "notif_list_4".tr(),
                  style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height <= 600 ? 9 : 10),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: BlocBuilder<NotifAllBloc, NotifAllState>(
          builder: (context, state) {
            if (state is NotifAllStateSuccessLoad) {
              return ListView.builder(
                  itemCount: state.models.length,
                  itemBuilder: (context, index) {
                    return NotificationBox(
                      size: size,
                      title: state.models[index].title,
                      date: state.models[index].createdDate,
                      onClick: () {
                        onClickList(state.models[index]);
                      },
                    );
                  });
            } else if (state is NotifAllStateFailed) {
              return emptyState(size);
            }
            return Container(
              height: 0.6 * size.height,
              width: 0.9 * size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget emptyState(Size size) {
    return Container(
      width: size.width,
      height: 0.7 * size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/Empty-Notif.svg",
              height: size.height < 569 ? 200 : 300,
              width: size.height < 569 ? 200 : 300),
          Text(
            "notif_list_2".tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 569 ? 18 : 22),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "notif_list_3".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size.height < 569 ? 12 : 14),
          )
        ],
      ),
    );
  }

  void onClickList(NotifModel model) {
    String text = model.about.toLowerCase();
    if (text == "contact supervisor") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenAnswerContact(
                    messageID: model.slugId.toString(),
                  )));
    } else if (text == "task") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenTab(
                    projectId: model.slugId.toString(),
                    gotoProject: true,
                    task: model.id,
                  )));
    } else if (text == "today meeting") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenTab(
                    gotoMeeting: true,
                    meetingId: model.slugId.toString(),
                  )));
    } else if (text == "meeting request") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RequestInbox()));
    }
  }
}
