import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-task.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            widget.projectName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: colorPrimary),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.plus,
                color: colorPrimary,
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
            ListView.builder(
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
            ListView.builder(
              itemCount: taskDone.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTaskDetail(title: taskDone[index], status: "done");
              },
            ),
          ],
        )));
  }
}
