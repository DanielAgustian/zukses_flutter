import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/project-bookmark/project-bookmark-bloc.dart';
import 'package:zukses_app_1/bloc/project-bookmark/project-bookmark-event.dart';
import 'package:zukses_app_1/bloc/project/project-bloc.dart';
import 'package:zukses_app_1/bloc/project/project-event.dart';
import 'package:zukses_app_1/bloc/project/project-state.dart';
import 'package:zukses_app_1/bloc/task/task-bloc.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';
import 'package:zukses_app_1/component/task/list-revise-project.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/screen/task/screen-add-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

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

  Future<bool> onWillPop() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenTab(
                  index: 0,
                )));
    return false;
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
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocListener<ProjectBloc, ProjectState>(
                    listener: (context, state) {
                      if (state is ProjectStateAddSuccessLoad) {
                        setState(() {
                          isLoading = true;
                        });
                        BlocProvider.of<ProjectBloc>(context)
                            .add(GetAllProjectEvent());
                      } else if (state is ProjectStateSuccessLoad) {
                        setState(() {
                          isLoading = false;
                          if (widget.projectId != null) {
                            ProjectModel project;
                            if (widget.projectId != null) {
                              for (int i = 0; i < state.project.length; i++) {
                                if (state.project[i].id.toString() ==
                                    widget.projectId) {
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
                        BlocProvider.of<ProjectBloc>(context)
                            .add(GetAllProjectEvent());
                      }
                    },
                    child: Container(),
                  ),
                  BlocListener<TaskBloc, TaskState>(
                    listener: (context, state) {
                      if (state is TaskStateSuccessLoad) {
                        BlocProvider.of<ProjectBloc>(context)
                            .add(GetAllProjectEvent());
                      }
                    },
                    child: Container(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildListProject(size),
                ],
              )),
              isLoading
                  ? Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.black38.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: colorPrimary70,
                          // strokeWidth: 0,
                          valueColor: AlwaysStoppedAnimation(colorBackground),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }

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
              text: 'No project listed at the moment. Click',
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
                    text: ' here',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: colorPrimary)),
                TextSpan(text: ' add a new Project'),
              ],
            ),
          )),
        );
      }
      return projects == null || projects.length == 0
          ? Container()
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
                        print("OnTapStar");
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

  
}
