import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/project/project-bloc.dart';
import 'package:zukses_app_1/bloc/project/project-event.dart';
import 'package:zukses_app_1/bloc/project/project-state.dart';
import 'package:zukses_app_1/bloc/task/task-bloc.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';
import 'package:zukses_app_1/component/task/list-revise-project.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/screen/task/screen-add-project.dart';
import 'package:zukses_app_1/screen/task/screen-task-detail.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key key, this.title}) : super(key: key);
  final String title;
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
        body: Stack(
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
                      });
                    } else if (state is ProjectStateFailLoad) {
                      setState(() {
                        isLoading = false;
                      });
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
                BlocBuilder<ProjectBloc, ProjectState>(
                    builder: (context, state) {
                  if (state is ProjectStateSuccessLoad) {
                    return ListView.builder(
                      itemCount: state.project.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              //print(projectName[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskDetailScreen(
                                          project: state.project[index],
                                        )),
                              );
                            },
                            child: ListReviseProject(
                              tag: state.bools[index],
                              image: state.project[index].imgUrl,
                              title: state.project[index].name,
                              detail: state.project[index].details,
                              jumlahTask: state.project[index].totalTask,
                              onTapStar: () {
                                print("OnTapStar");
                                setState(() {
                                  state.bools[index] = !state.bools[index];
                                });
                              },
                            ));
                      },
                    );
                  } else if (state is ProjectStateFailLoad) {
                    return Container(
                      width: size.width,
                      height: size.height * 0.75,
                      child: Center(
                          child: RichText(
                        text: TextSpan(
                          text: 'No Project Here. Click ',
                          style: TextStyle(color: colorPrimary),
                          children: <TextSpan>[
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddProject()));
                                  },
                                text: 'here',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorPrimary)),
                            TextSpan(text: ' to continue'),
                          ],
                        ),
                      )),
                    );
                  }
                  return Container();
                }),
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
        ));
  }

  void searchTask(String word) {}
}
