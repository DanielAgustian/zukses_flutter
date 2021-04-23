import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less-3.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/task/list-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';

class LayoutProjectList extends StatelessWidget {
  LayoutProjectList(
      {Key key,
      this.count,
      this.projectName,
      this.projectDetail,
      this.projectTask,
      this.time,
      this.fontSize = 22,
      this.loading = true,
      this.skeletonWidth = 180,
      this.size})
      : super(key: key);

  final double fontSize, skeletonWidth;
  final int count;
  final List<String> projectName, projectDetail;
  final List<int> projectTask;
  final String time;
  final bool loading;
  final Size size;
  //DateFormat dateFormat = DateFormat.yMMMMd();
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FOR SKELETON -------------------------------------------------------------------------
        loading
            ? SkeletonAnimation(
                shimmerColor: colorNeutral170,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorNeutral2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  width: 200,
                  height: 30,
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "You've got " + count.toString() + " tasks " + time,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      color: colorPrimary),
                ),
              ),

        // FOR SKELETON -------------------------------------------------------------------------
        loading
            ? ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SkeletonLess3(
                    size: size,
                  );
                },
              )
            : ListView.builder(
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
