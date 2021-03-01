import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/layout-project-list.dart';

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

  bool isLoading = true;

  void timer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    timer();
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
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 20 : 25,
                color: colorPrimary),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.bars,
                color: colorPrimary,
                size: size.height < 570 ? 20 : 25,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              //width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  color: colorNeutral150,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        color: Color.fromRGBO(240, 239, 242, 1),
                        blurRadius: 15),
                  ],
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextFormField(
                  controller: textSearch,
                  textInputAction: TextInputAction.go,
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
              height: 10,
            ),
            SizedBox(
              width: size.width,
              height: size.height,
              child: DefaultTabController(
                length: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Scaffold(
                      appBar: AppBar(
                        leading: Container(),
                        elevation: 0,
                        backgroundColor: colorBackground,
                        flexibleSpace: Container(
                            color: colorNeutral150,
                            child: TabBar(
                                controller: tabController,
                                labelColor: colorNeutral150,
                                unselectedLabelColor:
                                    colorFacebook.withOpacity(0.2),
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
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
                                loading: isLoading,
                                count: count,
                                fontSize: size.height <= 569 ? 18 : 22,
                                projectName: projectName,
                                projectDetail: projectDetail,
                                projectTask: projectTask,
                                time: "today",
                                skeletonWidth: size.height <= 570 ? 200 : 240),
                            LayoutProjectList(
                              loading: isLoading,
                              count: count,
                              fontSize: size.height <= 569 ? 18 : 22,
                              projectName: projectName,
                              projectDetail: projectDetail,
                              projectTask: projectTask,
                              time: "upcoming",
                            ),
                            LayoutProjectList(
                              loading: isLoading,
                              count: count,
                              fontSize: size.height <= 569 ? 18 : 22,
                              projectName: projectName,
                              projectDetail: projectDetail,
                              projectTask: projectTask,
                              time: "overdue",
                            )
                          ])),
                ),
              ),
            ),
          ],
        )));
  }

  void searchTask(String word) {}
}
