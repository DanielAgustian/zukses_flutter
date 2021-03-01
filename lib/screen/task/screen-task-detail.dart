import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-task.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-3r-2c.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isLoading
                ? ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Skeleton3R2C(size: size);
                    },
                  )
                : ListView.builder(
                    itemCount: taskName.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTaskDetail2(
                        title: taskName[index],
                        detail: taskDetail[index],
                        date: taskDate[index],
                        hour: taskHour[index],
                        index: index,
                      );
                    },
                  ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: colorPrimary50),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                          child: Text(
                            "Done",
                            style:
                                TextStyle(color: colorBackground, fontSize: 14),
                          ),
                        )))),
            isLoading
                ? ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SkeletonLess3(
                        size: size,
                        row: 1,
                        col: 1,
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: taskDone.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTaskDetail(
                          title: taskDone[index], status: "done");
                    },
                  ),
          ],
        )));
  }
}
