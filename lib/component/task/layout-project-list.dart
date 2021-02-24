import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LayoutProjectList extends StatelessWidget {
  LayoutProjectList(
      {Key key,
      this.count,
      this.projectName,
      this.projectDetail,
      this.projectTask,
      this.time,
      this.fontSize = 22})
      : super(key: key);

  final double fontSize;
  final int count;
  final List<String> projectName, projectDetail;
  final List<int> projectTask;
  final String time;
  //DateFormat dateFormat = DateFormat.yMMMMd();
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "You've got " + count.toString() + " tasks " + time,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: colorPrimary),
          ),
        ),
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
                  jumlahTask: projectTask[index],
                ));
          },
        ),
      ],
    );
  }
}
