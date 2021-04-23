import 'dart:async';
import 'dart:ui';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/change-task-bloc/change-task-bloc.dart';
import 'package:zukses_app_1/bloc/change-task-bloc/change-task-event.dart';
import 'package:zukses_app_1/bloc/checklist-task-put/checklist-task-put-bloc.dart';
import 'package:zukses_app_1/bloc/checklist-task-put/checklist-task-put-event.dart';
import 'package:zukses_app_1/bloc/checklist-task/checklist-task-bloc.dart';
import 'package:zukses_app_1/bloc/checklist-task/checklist-task-event.dart';
import 'package:zukses_app_1/bloc/checklist-task/checklist-task-state.dart';
import 'package:zukses_app_1/bloc/comment/comment-bloc.dart';
import 'package:zukses_app_1/bloc/comment/comment-event.dart';
import 'package:zukses_app_1/bloc/comment/comment-state.dart';
import 'package:zukses_app_1/bloc/task/task-bloc.dart';
import 'package:zukses_app_1/bloc/task/task-event.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/component/task/comment-box.dart';
import 'package:zukses_app_1/component/task/row-task.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/comment-model.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';

import 'package:zukses_app_1/util/util.dart';

/*class InnerList {
  final String name;
  List<String> children;
  InnerList({this.name, this.children});
}*/

// ignore: must_be_immutable
class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({Key key, this.title, this.project}) : super(key: key);
  final String title;
  ProjectModel project;
  //final String projectName;
  @override
  _TaskDetailScreen createState() => _TaskDetailScreen();
}

class _TaskDetailScreen extends State<TaskDetailScreen>
    with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  final textAddCheckBox = TextEditingController();

  //==================Method to Move =====================//
  String moveTo = "";
  String historyMoveTo = "";
  String changeMoveTo = "";
  var moveToList = ["To Do", "In Progress", "Done"];
  var dbEnum = ["to-do", "in-progress", "done"];

  var priorityList = ["High", "Medium", "Low"];
  String priority = "";

  var label = "";
  var labelList = ["Front End", "Back End", "Design"];

  //=======================================================//

  bool historyClick = true;

  int count = 4, activeIndex = 0;
  ScrollController _controller;
  Util util = Util();

  List<TaskModel> taskToDo = [];
  List<TaskModel> taskInProgress = [];
  List<TaskModel> taskDone = [];
  TaskModel clickTask = TaskModel();
  List<List<TaskModel>> dataTask = [];
  int checkClick = 0;

  AnimationController _animationController;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  bool checkBoxClick = false;
  bool postCommentValidator = false;
  Size size;

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
    label = labelList[0];
    priority = priorityList[0];
    moveTo = moveToList[0];
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_getTabIndex);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    BlocProvider.of<TaskBloc>(context)
        .add(GetAllTaskEvent(projectId: widget.project.id));
  }

  _postComment(CommentModel comment) {
    BlocProvider.of<CommentBloc>(context).add(AddCommentEvent(comment));
  }

  _searchEnum(String moving, String idtask) {
    for (int i = 0; i < moveToList.length; i++) {
      if (moving == moveToList[i]) {
        if (moving != historyMoveTo) {
          _changeProgress(moving, idtask);
        }
      }
    }
  }

  _changeProgress(String progress, String idTask) {
    BlocProvider.of<ChangeTaskBloc>(context)
        .add(ChangeTaskUpdateEvent(idTask, progress));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft, color: colorPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.project.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 570 ? 18 : 22,
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
                  MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                            projectId: widget.project.id,
                          )),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocListener<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is TaskStateSuccessLoad) {
                      taskToDo.clear();
                      state.task.forEach((element) {
                        if (element.taskType.toLowerCase() == "to-do") {
                          taskToDo.add(element);
                        } else if (element.taskType.toLowerCase() ==
                            "in progress") {
                          taskInProgress.add(element);
                        } else if (element.taskType.toLowerCase() == "done") {
                          taskDone.add(element);
                        }
                      });
                    }
                    dataTask = List.generate(3, (index) {
                      if (index == 0) {
                        return taskToDo;
                      } else if (index == 1) {
                        return taskInProgress;
                      }
                      return taskDone;
                    });
                  },
                  child: Container(),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height,
                  child: DefaultTabController(
                    length: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Scaffold(
                          appBar: AppBar(
                            leading: Container(),
                            elevation: 0,
                            backgroundColor: colorBackground,
                            flexibleSpace: Container(
                                color: colorNeutral150,
                                height: 30,
                                child: TabBar(
                                    onTap: (index) {
                                      _onTapIndex(index);
                                    },
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
                                        text: "ToDo",
                                      ),
                                      Tab(
                                        text: "In Progress",
                                      ),
                                      Tab(
                                        text: "Done",
                                      ),
                                    ])),
                          ),
                          body: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  width: 0,
                                  height: 0,
                                  child: TabBarView(
                                      controller: tabController,
                                      children: <Widget>[
                                        Container(),
                                        Container(),
                                        Container()
                                      ]),
                                ),
                                Expanded(
                                  child: DragAndDropLists(
                                    scrollController: _controller,
                                    children: List.generate(dataTask.length,
                                        (index) => _buildList(index)),
                                    onItemReorder: _onItemReorder,
                                    onListReorder: _onListReorder,
                                    axis: Axis.horizontal,
                                    listWidth: size.width * 0.85 - 5,
                                    listDraggingWidth: 300,
                                    listDecoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black45,
                                          spreadRadius: 3.0,
                                          blurRadius: 6.0,
                                          offset: Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    listPadding: EdgeInsets.all(8.0),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            )),
            clickTask.idTask == null ? Container() : scrollerSheet(clickTask),
          ],
        ));
  }

  String name = "";
  void dataIndex(int outerIndex) {
    if (outerIndex == 0) {
      setState(() {
        name = "To Do";
      });
    } else if (outerIndex == 1) {
      setState(() {
        name = "In Progress";
      });
    } else {
      setState(() {
        name = "Done";
      });
    }
  }

  _buildList(int outerIndex) {
    var innerList = dataTask[outerIndex];
    dataIndex(outerIndex);
    return DragAndDropList(
      header: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
          color: colorPrimary,
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          name,
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      leftSide: Divider(
        color: colorPrimary,
      ),
      canDrag: false,
      children: List.generate(
          innerList.length, (index) => _buildItem(innerList[index], index)),
    );
  }

  _buildItem(TaskModel item, index) {
    return DragAndDropItem(
      child: ListTaskDetail2(
        label: item.label,
        size: size,
        title: item.taskName,
        detail: item.details,
        date: util.yearFormat(DateTime.parse(item.date)),
        hour: util.hourFormat(DateTime.parse(item.date)),
        index: index,
        onClick: () {
          setState(() {
            if (item.taskType.toLowerCase() == "in progress") {
              historyMoveTo = dbEnum[1];
            } else {
              historyMoveTo = item.taskType.toLowerCase();
            }
          });
          for (int i = 0; i < dbEnum.length; i++) {
            if (item.taskType.toLowerCase() == dbEnum[i]) {
              setState(() {
                moveTo = moveToList[i];
              });
            } else {
              if (item.taskType.toLowerCase() == "in progress") {
                setState(() {
                  moveTo = moveToList[1];
                });
              }
            }
          }

          setState(() {
            clickTask = item;
            priority = item.priority;
          });
          BlocProvider.of<CommentBloc>(context)
              .add(LoadAllCommentEvent(item.idTask.toString()));

          BlocProvider.of<CLTBloc>(context)
              .add(LoadAllCLTEvent(item.idTask.toString()));
          _onClickItem(item);
        },
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = dataTask[oldListIndex].removeAt(oldItemIndex);

      dataTask[newListIndex].insert(newItemIndex, movedItem);

      _changeProgress(dbEnum[newListIndex], movedItem.idTask.toString());
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = dataTask.removeAt(oldListIndex);
      dataTask.insert(newListIndex, movedList);
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent - 320 &&
        !_controller.position.outOfRange) {
      setState(() {
        tabController.animateTo((2));
      });
    } else if (_controller.offset >=
            (_controller.position.maxScrollExtent / 2 - 165) &&
        !_controller.position.outOfRange) {
      setState(() {
        tabController.animateTo((1));
      });
    } else if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        tabController.animateTo((0));
      });
    }
  }

  void _getTabIndex() {
    activeIndex = tabController.index;
    print(activeIndex);
  }

  _onTapIndex(int index) {
    if (index == 0) {
      _controller.animateTo(_controller.position.minScrollExtent,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
    } else if (index == 1) {
      _controller.animateTo(_controller.position.maxScrollExtent / 2 - 165,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
    } else {
      _controller.animateTo(_controller.position.maxScrollExtent - 320,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
    }
  }

  _onClickItem(TaskModel task) {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  void _onCheckBoxClick(bool newValue) => setState(() {
        checkBoxClick = newValue;
      });

  Widget scrollerSheet(TaskModel clickTask) {
    bool temp = false;
    Size size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_animationController),
        child: DraggableScrollableSheet(
          maxChildSize: 0.9,
          initialChildSize: 0.8,
          minChildSize: 0.7,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 15)],
                  color: colorBackground,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _animationController.reverse();
                        },
                        child: Text("Cancel",
                            style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                      ),
                      InkWell(
                        onTap: () {
                          _searchEnum(moveTo, clickTask.idTask.toString());
                        },
                        child: Text("Done",
                            style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clickTask.taskName,
                        style: TextStyle(
                            fontSize: 20,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        clickTask.idTask.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary50,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Text(clickTask.details,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorNeutral3,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reporter",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: colorNeutral3,
                                        shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Member 1",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Assignee",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: colorNeutral3,
                                        shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Member 5",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              //pickTime(context, 1);
                            },
                            child: RowTaskUndroppable(
                              title: "End Time",
                              textItem: clickTask.date,
                              fontSize: size.height <= 600 ? 12 : 14,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TaskRow(
                              fontSize: size.height <= 569 ? 12 : 14,
                              title: "Move To",
                              textItem: moveTo,
                              items: moveToList,
                              onSelectedItem: (val) {
                                setState(() {
                                  moveTo = val;
                                });
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          RowTaskUndroppable(
                            title: "Label",
                            textItem: clickTask.label,
                            fontSize: size.height <= 600 ? 12 : 14,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RowTaskUndroppable(
                            title: "Priority",
                            textItem: clickTask.priority,
                            fontSize: size.height <= 600 ? 12 : 14,
                            priority: true,
                          ),

                          /*TaskRow2(
                              fontSize: size.height <= 569 ? 12 : 14,
                              title: "Priority",
                              textItem: priority,
                              items: priorityList,
                              onSelectedItem: (val) {
                                setState(() {
                                  priority = val;
                                });
                              }),*/
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorNeutral3),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Attachement",
                                style: TextStyle(
                                    color: colorPrimary, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: size.height * 0.2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: colorNeutral2,
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                height: size.height * 0.045,
                                decoration: BoxDecoration(
                                  color: colorNeutral3,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    "StatusImage.jpg",
                                    style: TextStyle(color: colorBackground),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorNeutral3),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "CheckList",
                                    style: TextStyle(
                                        color: colorPrimary, fontSize: 16),
                                  ),
                                ],
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorPrimary),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: colorBackground,
                                        size: 14,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          BlocBuilder<CLTBloc, CLTState>(
                              builder: (context, state) {
                            if (state is CLTStateGetSuccessLoad) {
                              return ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.listCheckList.length + 1, //+ 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index == state.listCheckList.length) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      child: CheckboxListTile(
                                          value: checkBoxClick,
                                          onChanged: _onCheckBoxClick,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: _textBoxCheck(
                                              context, clickTask.idTask)),
                                    );
                                  }
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: CheckboxListTile(
                                      value: state.boolCheckList[index],
                                      onChanged: (val) {
                                        setState(() {
                                          state.boolCheckList[index] =
                                              !state.boolCheckList[index];
                                        });
                                        BlocProvider.of<CLTPBloc>(context).add(
                                            PutCLTPEvent(state
                                                .listCheckList[index].id
                                                .toString()));
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                          state.listCheckList[index].checkList,
                                          style: TextStyle(
                                              fontSize:
                                                  size.height <= 569 ? 12 : 14,
                                              color: colorPrimary,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                },
                              );
                            } else if (state is CLTStateGetFailLoad) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: CheckboxListTile(
                                    value: checkBoxClick,
                                    onChanged: _onCheckBoxClick,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: _textBoxCheck(
                                        context, clickTask.idTask)),
                              );
                            } else if (state is CLTStateAddSuccessLoad) {
                              BlocProvider.of<CLTBloc>(context).add(
                                  LoadAllCLTEvent(clickTask.idTask.toString()));
                            }
                            return Container();
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorNeutral3),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    historyClick
                                        ? "Activity Log - Comment"
                                        : "Activity Log - History",
                                    style: TextStyle(
                                        color: colorPrimary, fontSize: 16),
                                  ),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      historyClick = !historyClick;
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: historyClick
                                              ? colorPrimary
                                              : colorPrimary30,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        historyClick ? "History" : "Comment",
                                        style: TextStyle(
                                            color: historyClick
                                                ? colorBackground
                                                : colorPrimary,
                                            fontSize: 14,
                                            fontWeight: historyClick
                                                ? FontWeight.bold
                                                : FontWeight.w500),
                                      )))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          historyClick
                              ? BlocBuilder<CommentBloc, CommentState>(
                                  builder: (context, state) {
                                    if (state is CommentStateGetSuccessLoad) {
                                      return ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: state.comment.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return CommentBox(
                                                size: size,
                                                comment: state
                                                    .comment[index].content,
                                                user: state
                                                    .comment[index].nameUser,
                                                date: util.dateNumbertoCalendar(
                                                        state.comment[index]
                                                            .date) +
                                                    " at " +
                                                    util.hourFormat(state
                                                        .comment[index].date));
                                          });
                                    } else if (state
                                        is CommentStateGetFailLoad) {
                                      return Text("No Comment Yet");
                                    } else if (state
                                        is CommentStateAddSuccessLoad) {
                                      BlocProvider.of<CommentBloc>(context).add(
                                          LoadAllCommentEvent(
                                              clickTask.idTask.toString()));
                                      return CircularProgressIndicator();
                                    }
                                    return Container();
                                  },
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 2,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return HistoryBox(
                                        size: size,
                                        history:
                                            "Lorem ipsum dolor sit amet, cboboa sl anapisna pna pindo aoad n[oa k doa a[ da[on a",
                                        user: "Finley Khouwira",
                                        date: DateTime.now());
                                  }),
                          PostBox(
                              date: DateTime.now(),
                              onPost: () {
                                if (textEditingController.text != "") {
                                  setState(() {
                                    postCommentValidator = false;
                                  });
                                } else {
                                  setState(() {
                                    postCommentValidator = true;
                                  });
                                }
                                if (!postCommentValidator) {
                                  CommentModel commentModel = CommentModel(
                                      taskID: clickTask.idTask,
                                      content: textEditingController.text);
                                  _postComment(commentModel);
                                }
                              },
                              user: UserModel(userID: "41", name: "Daniel"),
                              size: size,
                              textEditController: textEditingController)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _textBoxCheck(context, int taskId) {
    return Container(
      width: 0.5 * size.width,
      decoration: BoxDecoration(
        boxShadow: [boxShadowStandard],
        color: colorBackground,
        border: Border.all(width: 1, color: colorPrimary),
      ),
      child: TextField(
        style: TextStyle(fontSize: 16, height: 1.0),
        textInputAction: TextInputAction.next,
        onChanged: (val) {},
        controller: textAddCheckBox,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 15, left: 10),
            hintText: "Add new list...",
            hintStyle: TextStyle(
              color: colorNeutral1,
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: TextButton(
                child: Text(
                  "Post",
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: size.height < 569 ? 14 : 16,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (textAddCheckBox.text != "") {
                    BlocProvider.of<CLTBloc>(context).add(
                        AddCLTEvent(taskId.toString(), textAddCheckBox.text));
                  }
                })),
      ),
    );
  }
}
