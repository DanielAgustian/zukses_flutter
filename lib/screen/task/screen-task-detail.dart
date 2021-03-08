import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/task/layout-project-list.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-task.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-3r-2c.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/screen/task/screen-dragdrop-temp.dart';

class InnerList {
  final String name;
  List<String> children;
  InnerList({this.name, this.children});
}

class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({Key key, this.title, this.projectName}) : super(key: key);
  final String title;
  final String projectName;
  @override
  _TaskDetailScreen createState() => _TaskDetailScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskDetailScreen extends State<TaskDetailScreen> {
  var taskName = ["task 1", "Task 2", "Task4", "Task 6"];
  var taskDone = ["task 3", "task 5"];
  var taskDetail = ["Dadada", "nananan", "mamammaa", "lalalla"];
  var taskDate = ["02/19/2020", "08/19/2020", "12/11/2019", "02/15/2021"];
  var taskHour = ["19.00", "17.00", "15.00", "16.00"];
  int count = 4;
  var projectTask = [1, 5, 2, 0];
  TabController tabController;
  // FOR SKELETON -------------------------------------------------------------------------
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
    timer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Kanban()),
            );
          },
        ),
        backgroundColor: colorBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.projectName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 570 ? 22 : 25,
                color: colorPrimary),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.plus,
                color: colorPrimary,
                size: size.height < 570 ? 20 : 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
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
                                size: size,
                                loading: isLoading,
                                count: count,
                                fontSize: size.height <= 569 ? 18 : 22,
                                projectName: taskName,
                                projectDetail: taskDetail,
                                projectTask: projectTask,
                                time: "today",
                                skeletonWidth: size.height <= 570 ? 200 : 240),
                            LayoutProjectList(
                              size: size,
                              loading: isLoading,
                              count: count,
                              fontSize: size.height <= 569 ? 18 : 22,
                              projectName: taskName,
                              projectDetail: taskDetail,
                              projectTask: projectTask,
                              time: "upcoming",
                            ),
                            LayoutProjectList(
                              size: size,
                              loading: isLoading,
                              count: count,
                              fontSize: size.height <= 569 ? 18 : 22,
                              projectName: taskName,
                              projectDetail: taskDetail,
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
}
