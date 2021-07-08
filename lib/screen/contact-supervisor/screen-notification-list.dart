import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/bloc/notif-all/notif-all-bloc.dart';
import 'package:zukses_app_1/component/notification/notification-box.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/notif-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-answer-contact.dart';
import 'package:zukses_app_1/screen/meeting/screen-req-inbox.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

class ScreenNotificationList extends StatefulWidget {
  ScreenNotificationList();
  _ScreenNotificationList createState() => _ScreenNotificationList();
}

class _ScreenNotificationList extends State<ScreenNotificationList> {
  @override
  void initState() {
    // TODO: implement initState
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
          "Notification List",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 22),
        ),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
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
                  )));
    } else if (text == "today meeting") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScreenTab(
                    gotoMeeting: true,
                  )));
    } else if (text == "meeting request") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RequestInbox()));
    }
  }
}
