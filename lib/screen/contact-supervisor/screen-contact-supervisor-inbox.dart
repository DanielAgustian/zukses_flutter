import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/send-feedback/contact-spv-box.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/model/list-contact-spv-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-answer-contact.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-contact-supervisor.dart';

class ScreenContactSupervisorInbox extends StatefulWidget {
  ScreenContactSupervisorInbox();

  _ScreenContactSupervisorInbox createState() =>
      _ScreenContactSupervisorInbox();
}

class _ScreenContactSupervisorInbox extends State<ScreenContactSupervisorInbox>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    getList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorPrimary,
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenContactSupervisor(
                          data: "others",
                        )));
          },
        ),
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
        body: Stack(
          children: [
            DefaultTabController(
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
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "New Messages",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    //positionedDot(context, size, requestSchedule[0])
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text("Processed"),
                                    ),
                                    //positionedDot(context, size, requestSchedule[1])
                                  ],
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text("Read"),
                                    ),
                                    //positionedDot(context, size, requestSchedule[1])
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: BlocBuilder<ListCSVBloc, ListCSVState>(
                        builder: (context, state) {
                      if (state is ListCSVGetListStateSuccess) {
                        List<ContactSupervisorListModel> modelNewMSG = [];
                        List<ContactSupervisorListModel> modelSending = [];
                        List<ContactSupervisorListModel> modelRead = [];

                        state.model.forEach((element) {
                          if (element.status.toLowerCase() == "sent") {
                            modelSending.add(element);
                          } else if (element.status.toLowerCase() ==
                              "new message") {
                            modelNewMSG.add(element);
                          } else if (element.status.toLowerCase() == "read") {
                            modelRead.add(element);
                          }
                        });
                        return Container(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              listNewMessages(context, size, modelNewMSG),
                              listNewMessages(context, size, modelSending),
                              listNewMessages(context, size, modelRead),
                            ],
                          ),
                        );
                      } else if (state is ListCSVGetListStateFailed) {
                        List<ContactSupervisorListModel> model = [];
                        return Container(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              listNewMessages(context, size, model),
                              listNewMessages(context, size, model),
                              listNewMessages(context, size, model),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }))),
          ],
        ));
  }

  Widget listNewMessages(
      BuildContext context, Size size, List<ContactSupervisorListModel> model) {
    if (model != null && model.length > 0) {
      return ListView.builder(
          itemCount: model.length,
          itemBuilder: (context, index) {
            return ContactSPVBox(
              onClick: () {
                gotoAnswer(model[index].messageId.toString());
              },
              onDelete: () {
                deleteData(model[index].messageId.toString());
              },
              title: model[index].name,
              date: model[index].time,
              size: size,
              linkPicture: model[index].photo,
              detail: model[index].about,
            );
          });
    }
    return Container(
      color: colorBackground,
      height: 0.8 * size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 0.33 * size.width,
              width: 0.33 * size.width,
              child: SvgPicture.asset("assets/images/empty-contact-spv.svg"),
            ),
            SizedBox(
              height: 0.05 * size.height,
            ),
            Text(
              "You dont have any messages Yet",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: size.height < 569 ? 16 : 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 0.03 * size.height,
            ),
            Text(
              "Your message will appear on this page automatically",
              style: TextStyle(
                color: Colors.black,
                fontSize: size.height < 569 ? 14 : 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  getList() {
    BlocProvider.of<ListCSVBloc>(context).add(ListCSVGetListEvent());
  }

  deleteData(String id) {
    BlocProvider.of<ContactSupervisorBloc>(context)
        .add(ContactSupervisorDeleteEvent(conversationId: id));
    Navigator.pop(context);
    getList();
  }

  gotoAnswer(String messageId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenAnswerContact(
                  messageID: messageId,
                )));
  }
}
