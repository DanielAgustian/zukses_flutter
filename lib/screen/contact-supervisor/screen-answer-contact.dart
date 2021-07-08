import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-bloc.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-event.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-state.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/component/send-feedback/text-row.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/model/contact-supervisor-modal.dart';
import 'package:zukses_app_1/util/util.dart';

class ScreenAnswerContact extends StatefulWidget {
  ScreenAnswerContact({this.messageID});
  final String messageID;
  _ScreenAnswerContact createState() => _ScreenAnswerContact();
}

class _ScreenAnswerContact extends State<ScreenAnswerContact> {
  final textMessage = TextEditingController();
  bool response = false;
  String myId = "";
  bool emptyMessage = false;
  String messageId;
  @override
  void initState() {
    super.initState();
    //messageId = "3";
    messageId = widget.messageID;

    _getMyID();
    BlocProvider.of<ContactSupervisorBloc>(context)
        .add(ContactSupervisorGetEvent(conversationId: messageId));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("contact_spv_1".tr(),
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height <= 600 ? 20 : 22)),
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
        ),
        body: BlocBuilder<ContactSupervisorBloc, ContactSupervisorState>(
            builder: (context, state) {
          if (state is ContactSupervisorGetStateSuccess) {
            List<ContactSupervisorModel> model = state.model;
            // print("myID in blocbuilder" + myId);
            bool answered = state.lastConversation.senderId.toString() != myId;
            // print("bool answered" + answered.toString());
            int status = state.myLastConversation.status;
            //print("status lc" + status.toString());
            DateTime initialDate = state.model[0].messageTime;

            return SingleChildScrollView(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal, vertical: paddingVertical),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextRowSendFeedback(
                      title: "Status",
                      textItem: statusString(status, answered),
                      fontSize: size.height < 569 ? 14 : 16,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextRowSendFeedback(
                      title: "Detail",
                      textItem: Util().dateNumbertoCalendar(initialDate),
                      fontSize: size.height < 569 ? 14 : 16,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.centerRight,
                      child: Text(Util().dateTimeToTimeOfDay(initialDate),
                          style: TextStyle(
                              fontSize: size.height < 569 ? 14 : 16,
                              color: colorGoogle,
                              fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    printData(context, size, model, myId),
                    SizedBox(
                      height: 15,
                    ),
                    response
                        ? Container()
                        : Container(
                            alignment: Alignment.centerRight,
                            width: size.width,
                            child: SmallButton(
                              onClick: () {
                                setState(() {
                                  response = !response;
                                });
                              },
                              title: "contact_spv_7".tr(),
                              bgColor: colorPrimary,
                              textColor: colorBackground,
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    response
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "contact_spv_2".tr(),
                                style: TextStyle(
                                    fontSize: size.height < 569 ? 14 : 16,
                                    color: colorGoogle,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: emptyMessage
                                            ? colorError
                                            : Colors.transparent),
                                    color: colorBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorNeutral1.withOpacity(1),
                                        blurRadius: 15,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextFormField(
                                  maxLines: 8,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  controller: textMessage,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(20),
                                      hintText: "contact_spv_3".tr(),
                                      hintStyle: TextStyle(
                                        color: emptyMessage
                                            ? colorError
                                            : colorNeutral1,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: size.width,
                                child: SmallButton(
                                  onClick: () {
                                    _answerData(state
                                        .myLastConversation.receiverId
                                        .toString());
                                  },
                                  title: "contact_spv_8".tr(),
                                  bgColor: colorPrimary,
                                  textColor: colorBackground,
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            );
          } else if (state is ContactSupervisorAnswerStateSuccess) {
            BlocProvider.of<ContactSupervisorBloc>(context)
                .add(ContactSupervisorGetEvent(conversationId: messageId));
          }
          return Container(
            width: size.width,
            height: size.height * 0.7,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }

  Widget printData(BuildContext context, Size size,
      List<ContactSupervisorModel> model, String myId) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                myId == model[index].senderId.toString()
                    ? "contact_spv_9".tr()
                    : "contact_spv_10".tr(),
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                model[index].message,
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16, color: colorPrimary),
              ),
              SizedBox(
                height: 15,
              )
            ],
          );
        });
  }

  String statusString(int status, bool answered) {
    if (answered) {
      return "contact_spv_11".tr();
    } else {
      if (status == 0) {
        return "contact_spv_12".tr();
      } else if (status == 1) {
        return "contact_spv_13".tr();
      }
      return "error";
    }
  }

  _getMyID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = prefs.getString('myID');
    print(myId);
  }

  _answerData(String receiverId) {
    if (textMessage.text.length < 1) {
      setState(() {
        emptyMessage = true;
      });
    } else {
      setState(() {
        emptyMessage = false;
      });
    }
    if (!emptyMessage) {
      BlocProvider.of<ContactSupervisorBloc>(context).add(
          ContactSupervisorAnswerEvent(
              message: textMessage.text,
              messageId: messageId,
              receiverId: receiverId));
    }
  }
}
