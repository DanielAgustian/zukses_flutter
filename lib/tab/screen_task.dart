import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TaskScreen createState() => _TaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskScreen extends State<TaskScreen> {
  var projectName = ["Project 1", "Project 2", "Project 3", "Project 4"];
  var projectDetail = [
    "Project 1: Batman",
    "Project 2: Golor",
    "Project 3: Dummy Project",
    "Project 4: Liar"
  ];
  var projectTask = [1, 5, 2, 0];
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
            "You've got " + count.toString() + " tasks today",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: colorPrimary),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              itemCount: projectName.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      print(projectName[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                                  projectName: projectName[index],
                                )),
                      );
                    },
                    child: ListProject(
                      title: projectName[index],
                      detail: projectDetail[index],
                      jumlahTask: projectTask[index].toInt(),
                    ));
              },
            ),
          ],
        )));
  }
}
