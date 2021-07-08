import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-bloc.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-event.dart';
import 'package:zukses_app_1/bloc/contact-supervisor/contact-supervisor-state.dart';
import 'package:zukses_app_1/component/send-feedback/contact-spv-box.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/model/list-contact-spv-model.dart';

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
                body:
                    BlocBuilder<ContactSupervisorBloc, ContactSupervisorState>(
                        builder: (context, state) {
                  if (state is ContactSupervisorGetListStateSuccess) {
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
                  } else if (state is ContactSupervisorAddStateSuccess) {
                    getList();
                  } else if (state is ContactSupervisorAnswerStateSuccess) {
                    getList();
                  } else if (state is ContactSupervisorGetStateSuccess) {
                    getList();
                  } else if (state is ContactSupervisorGetListStateFailed) {
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
                }))));
  }

  Widget listNewMessages(
      BuildContext context, Size size, List<ContactSupervisorListModel> model) {
    if (model != null) {
      return ListView.builder(
          itemCount: model.length,
          itemBuilder: (context, index) {
            return ContactSPVBox(
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("ContactSupervisor Empty")],
        ),
      ),
    );
  }

  getList() {
    BlocProvider.of<ContactSupervisorBloc>(context)
        .add(ContactSupervisorGetListEvent());
  }
}
