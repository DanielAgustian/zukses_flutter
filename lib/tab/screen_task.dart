import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/task/list-revise-project.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/screen/task/screen-add-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:easy_localization/easy_localization.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, this.title, this.projectId}) : super(key: key);
  final String title;
  final String projectId;
  @override
  _TaskScreen createState() => _TaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskScreen extends State<TaskScreen> {
  TextEditingController textSearch = new TextEditingController();
  var projectTask = [1, 5, 2, 0];
  int count = 4;
  int tab = 0;
  String text = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
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
            "Project List",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 18 : 22,
                color: colorPrimary),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.plusCircle,
                color: colorPrimary,
                size: size.height < 570 ? 20 : 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProject()),
                );
              },
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: RefreshIndicator(
            color: colorPrimary,
            strokeWidth: 1,
            onRefresh: refreshData,
            child: MultiBlocListener(
                listeners: listeners(),
                child: Stack(
                  children: [
                    buildListProject(size),
                    isLoading
                        ? BackdropFilter(
                            filter:
                                new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Container(
                              width: size.width,
                              height: size.height,
                              color: Colors.white.withOpacity(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: colorPrimary70,
                                    valueColor:
                                        AlwaysStoppedAnimation(colorBackground),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                )),
          ),
        ));
  }

  // Widget to build project list
  Widget buildListProject(Size size) {
    List<ProjectModel> projects;
    List<bool> bools;

    return BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
      if (state is ProjectStateSuccessLoad) {
        projects = state.project;
        bools = state.bools;
      } else if (state is ProjectStateFailLoad) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: size.width,
          height: size.height * 0.75,
          child: Center(
              child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'task_text30'.tr(),
              style: TextStyle(color: colorPrimary),
              children: <TextSpan>[
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProject()));
                      },
                    text: 'task_text31'.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: colorPrimary)),
                TextSpan(text: 'task_text32'.tr()),
              ],
            ),
          )),
        );
      }
      return projects == null || projects.length == 0
          ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), child: Container())
          : ListView.builder(
              itemCount: projects.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                                  project: projects[index],
                                )),
                      );
                    },
                    child: ListReviseProject(
                      tag: bools[index],
                      image: projects[index].imgUrl,
                      title: projects[index].name,
                      detail: projects[index].details,
                      jumlahTask: projects[index].totalTask,
                      onTapStar: () {
                        setState(() {
                          bools[index] = !bools[index];
                          BlocProvider.of<ProjectBookmarkBloc>(context).add(
                              DoProjectBookmarkEvent(
                                  projects[index].id.toString()));
                        });
                      },
                    ));
              },
            );
    });
  }

  // --------------------------Logic-----------------------------//

  Future<void> refreshData() async {
    BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
  }

  List<BlocListener> listeners() => [
        BlocListener<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is ProjectStateAddSuccessLoad) {
              setState(() {
                isLoading = true;
              });
              BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
            } else if (state is ProjectStateSuccessLoad) {
              setState(() {
                isLoading = false;
                if (widget.projectId != null) {
                  ProjectModel project;
                  if (widget.projectId != null) {
                    for (int i = 0; i < state.project.length; i++) {
                      if (state.project[i].id.toString() == widget.projectId) {
                        project = state.project[i];
                      }
                    }
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(
                                project: project,
                              )));
                }
              });
            } else if (state is ProjectStateFailLoad) {
              setState(() {
                isLoading = false;
              });
            } else if (state is ProjectStateAddFailLoad) {
              BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
            }
          },
        ),
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskStateSuccessLoad) {
              BlocProvider.of<ProjectBloc>(context).add(GetAllProjectEvent());
            }
          },
        )
      ];

  // Function to handle click back on android
  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenTab(
                  index: 0,
                )));
    return false;
  }
}
