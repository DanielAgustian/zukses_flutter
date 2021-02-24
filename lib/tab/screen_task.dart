import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-project.dart';
import 'package:zukses_app_1/component/task/layout-project-list.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TaskScreen createState() => _TaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskScreen extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  var projectName = ["Project 1", "Project 2", "Project 3", "Project 4"];
  var projectDetail = [
    "Project 1: Batman",
    "Project 2: Golor",
    "Project 3: Dummy Project",
    "Project 4: Liar"
  ];
  TabController tabController;
  TextEditingController textSearch = new TextEditingController();
  var projectTask = [1, 5, 2, 0];
  int count = 4;
  int tab = 0;
  String text = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          automaticallyImplyLeading: false,
          //centerTitle: true,
          title: Text(
            "My Task",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: colorPrimary),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: colorPrimary,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
              child: Container(
                height: 50,
                //width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: textSearch,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: FaIcon(FontAwesomeIcons.search,
                            color: colorPrimary),
                        onPressed: () {
                          setState(() {
                            searchTask(textSearch.text);
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      hintText: "Search..",
                      hintStyle: TextStyle(),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                    appBar: AppBar(
                      leading: Container(),
                      backgroundColor: colorBackground,
                      flexibleSpace: SafeArea(
                          child: TabBar(
                              controller: tabController,
                              labelColor: colorBackground,
                              unselectedLabelColor: colorPrimary,
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height <= 569 ? 14 : 16),
                              indicator: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.circular(5)),
                              tabs: [
                            Tab(
                              text: "Today",
                            ),
                            Tab(
                              text: "Upcoming",
                            ),
                            Tab(
                              text: "Overdue",
                            ),
                          ])),
                    ),
                    body: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          LayoutProjectList(
                            count: count,
                            projectName: projectName,
                            projectDetail: projectDetail,
                            projectTask: projectTask,
                            time: "today",
                          ),
                          LayoutProjectList(
                            count: count,
                            projectName: projectName,
                            projectDetail: projectDetail,
                            projectTask: projectTask,
                            time: "upcoming",
                          ),
                          LayoutProjectList(
                            count: count,
                            projectName: projectName,
                            projectDetail: projectDetail,
                            projectTask: projectTask,
                            time: "overdue",
                          )
                        ])),
              ),
            ),
          ],
        )));
  }

  void searchTask(String word) {}
}
