import 'dart:io';
import 'dart:ui';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:recase/recase.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zukses_app_1/component/task/comment-box.dart';
import 'package:zukses_app_1/component/task/row-task.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/comment-model.dart';
import 'package:zukses_app_1/model/label-task-model.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zukses_app_1/util/util_string_lang.dart';

// ignore: must_be_immutable
class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({Key key, this.title, this.project, this.task})
      : super(key: key);
  final String title;
  ProjectModel project;
  int task;
  //final String projectName;
  @override
  _TaskDetailScreen createState() => _TaskDetailScreen();
}

class _TaskDetailScreen extends State<TaskDetailScreen>
    with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  final textAddCheckBox = TextEditingController();
  final textEditCheckList = TextEditingController();
  final picker = ImagePicker();

  DateTime date;
  String data = "";
  //==================Method to Move =====================//
  String moveTo = "";
  String historyMoveTo = "";
  String changeMoveTo = "";
  var moveToList = ["task_text5".tr(), "task_text6".tr(), "task_text7".tr()];
  var dbEnum = ["to-do", "in-progress", "done"];

  var priorityList = [
    "priority_text1".tr(),
    "priority_text2".tr(),
    "priority_text3".tr()
  ];
  String priority = "";

  List<LabelTaskModel> label = [];
  List<String> labelList = [];
  String chooseLabel = "";
  //var label = "";
  UtilStringLang utilP = UtilStringLang();
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
  bool upload = false;
  Size size;

  int lengthTask = 0;
  var projectTask = [1, 5, 2, 0];
  TabController tabController;
  String name = "";
  // FOR SKELETON -------------------------------------------------------------------------
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    priority = priorityList[0];
    moveTo = moveToList[0];
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_getTabIndex);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _getLabel();
    BlocProvider.of<TaskBloc>(context)
        .add(GetAllTaskEvent(projectId: widget.project.id));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: colorBackground,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          UserModel user;
          if (state is UserDataStateSuccessLoad) {
            user = state.userModel;
          }
          return IconButton(
              icon: FaIcon(FontAwesomeIcons.chevronLeft, color: colorPrimary),
              onPressed: () {
                if (user.companyID != null) {
                  if (user.companyID != "") {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScreenTab(
                                  index: 2,
                                )));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScreenTab(
                                  index: 1,
                                )));
                  }
                }
              });
        },
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
    );
    AppBar insideAppBar = AppBar(
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
              unselectedLabelColor: colorFacebook.withOpacity(0.2),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                  color: colorPrimary, borderRadius: BorderRadius.circular(5)),
              tabs: [
                Tab(
                  text: "task_text5".tr(),
                ),
                Tab(text: "task_text6".tr()),
                Tab(
                  text: "task_text7".tr(),
                ),
              ])),
    );
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: appBar,
        body: MultiBlocListener(
          listeners: listeners(),
          child: Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(35),
                        child: insideAppBar,
                      ),
                      body: Container(
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
                            lengthTask < 1
                                ? Container(
                                    height: 0.6 * size.height,
                                    child: Center(
                                      child: Text("task_text29".tr(),
                                          style: TextStyle(
                                              color: colorPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ))
                                : Expanded(
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
              clickTask.idTask == null ? Container() : scrollerSheet(clickTask),
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

  //Widget forview detail in draggable scroll sheet
  Widget scrollerSheet(TaskModel clickTask) {
    Size size = MediaQuery.of(context).size;
    print("clickTask Attachment" + clickTask.attachment.length.toString());
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
                        child: Text("cancel_text".tr(),
                            style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                      ),
                      InkWell(
                        onTap: () {
                          _clickDoneScroller(clickTask);
                        },
                        child: Text("done_text".tr(),
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
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "task_text8".tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                width: 0.45 * size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    clickTask.reporter.imgUrl == null ||
                                            clickTask.reporter.imgUrl == ""
                                        ? Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                /*image: DecorationImage(
                                            image: NetworkImage()
                                          ),*/
                                                color: colorPrimary,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                util.getInitials(
                                                    clickTask.reporter.name),
                                                style: TextStyle(
                                                    color: colorBackground,
                                                    fontSize: 12),
                                              ),
                                            ))
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    image: NetworkImage(
                                                        "https://api-zukses.yokesen.com/${clickTask.reporter.imgUrl}")),
                                                color: colorPrimary,
                                                shape: BoxShape.circle),
                                          ),
                                    SizedBox(width: 10),
                                    Container(
                                      width: 0.35 * size.width,
                                      child: Text(clickTask.reporter.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  size.height < 569 ? 12 : 14)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          clickTask.assignment.length > 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "task_text9".tr(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: colorPrimary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    //ListViewAssigneee Here
                                    listViewAssignee(clickTask, size)
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              DateTime dateDB = DateTime.parse(clickTask.date);
                              dateUpdatePicker(
                                  dateDB, TimeOfDay.fromDateTime(dateDB));
                            },
                            child: RowTaskUndroppable(
                              title: "team_member_text2".tr(),
                              textItem: date != null
                                  ? util.dateNumbertoCalendar(date) +
                                      " at " +
                                      util.dateTimeToTimeOfDay(date)
                                  : util.dateNumbertoCalendar(
                                          DateTime.parse(clickTask.date)) +
                                      " at " +
                                      util.dateTimeToTimeOfDay(
                                          DateTime.parse(clickTask.date)),
                              fontSize: size.height <= 600 ? 12 : 14,
                              needArrow: true,
                              changeColor: date != null
                                  ? dateCalculationforLateness(date.toString())
                                  : dateCalculationforLateness(clickTask.date),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TaskRow(
                              fontSize: size.height <= 569 ? 12 : 14,
                              title: "task_text11".tr(),
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
                          clickTask.label == null
                              ? Container()
                              : TaskRow(
                                  fontSize: size.height <= 569 ? 12 : 14,
                                  title: "label_text".tr(),
                                  textItem: chooseLabel,
                                  items: labelList,
                                  onSelectedItem: (val) {
                                    setState(() {
                                      chooseLabel = val;
                                    });
                                  }),
                          clickTask.label == null
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          TaskRow2(
                            items: priorityList,
                            title: "task_text12".tr(),
                            textItem: utilP.priorityTransformation(
                                priority, priorityList),
                            fontSize: size.height <= 600 ? 12 : 14,
                            onSelectedItem: (val) {
                              setState(() {
                                priority = utilP.priorityDeTransformation(val);
                              });
                            },
                          ),
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
                                "task_text13".tr(),
                                style: TextStyle(
                                    color: colorPrimary, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          buildUploadAttach(),
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
                                        color: Colors.transparent),
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
                          SizedBox(height: 5),
                          buildCheckboxListTile(),
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
                                    historyClick
                                        ? "task_text15".tr()
                                        : "task_text26".tr(),
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
                              ? buildCommentSection(size, clickTask)
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

  Widget listViewAssignee(TaskModel tasks, Size size) {
    return Expanded(
      flex: 2,
      child: ListView.builder(
          itemCount: tasks.assignment.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width:
                      size.height < 569 ? 0.45 * size.width : 0.45 * size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      tasks.assignment[index].imgUrl == null ||
                              tasks.assignment[index].imgUrl == ""
                          ? Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: colorPrimary, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  util.getInitials(
                                      tasks.assignment[index].name),
                                  style: TextStyle(
                                      color: colorBackground, fontSize: 12),
                                ),
                              ))
                          : Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(
                                          "https://api-zukses.yokesen.com/${tasks.assignment[index].imgUrl}")),
                                  color: colorPrimary,
                                  shape: BoxShape.circle),
                            ),
                      SizedBox(width: 10),
                      Container(
                        width: 0.35 * size.width,
                        child: Text(
                          tasks.assignment[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildUploadAttach() {
    return BlocBuilder<UploadAttachBloc, UploadAttachState>(
        builder: (context, state) {
      if (state is UploadAttachStateSuccessLoad) {
        return Container(
          height: 150,
          child: Stack(
            children: [
              SizedBox(
                child: ListView.builder(
                    itemCount: state.attach.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => _buildCupertino(
                                    context: context,
                                    link: state.attach[index].attachment));
                          },
                          child: Container(
                            height: size.height * 0.2,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: colorNeutral2,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(
                                      "https://api-zukses.yokesen.com/" +
                                          state.attach[index].attachment),
                                )),
                          ),
                        ),
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
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
                        "Click Here to Upload",
                        style: TextStyle(color: colorBackground),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (state is UploadAttachStateFailLoad) {
        return Container(
          height: size.height * 0.2,
          width: double.infinity,
          decoration: BoxDecoration(
              color: colorNeutral2,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: data == ""
                      ? AssetImage("assets/images/camera.png")
                      : FileImage(File(data)))),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                _showPicker(context);
              },
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
                    upload ? "Upload Success" : "Click Here to Upload",
                    style: TextStyle(color: colorBackground),
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (state is UploadAttachStateSuccess) {
        BlocProvider.of<UploadAttachBloc>(context)
            .add(UploadAttachGetEvent(clickTask.idTask.toString()));
        return Container();
      }
      return Container();
    });
  }

  Widget buildCheckboxListTile() {
    return BlocBuilder<CLTBloc, CLTState>(builder: (context, state) {
      if (state is CLTStateGetSuccessLoad) {
        return ListView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.listCheckList.length + 1, //+ 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index == state.listCheckList.length) {
              return Container(
                  alignment: Alignment.centerLeft,
                  child: _textBoxCheck(context, clickTask.idTask)
                  // CheckboxListTile(
                  //     value: checkBoxClick,
                  //     onChanged: _onCheckBoxClick,
                  //     controlAffinity: ListTileControlAffinity.leading,
                  //     title: _textBoxCheck(context, clickTask.idTask)),
                  );
            }
            return Container(
              alignment: Alignment.centerLeft,
              child: CheckboxListTile(
                value: state.boolCheckList[index],
                onChanged: (val) {
                  setState(() {
                    state.boolCheckList[index] = !state.boolCheckList[index];
                  });
                  BlocProvider.of<CLTPBloc>(context).add(
                      PutCLTPEvent(state.listCheckList[index].id.toString()));
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    state.boolCheckList[index]
                        ? Text(state.listCheckList[index].checkList,
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: size.height <= 569 ? 12 : 14,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold))
                        : Text(state.listCheckList[index].checkList,
                            style: TextStyle(
                                fontSize: size.height <= 569 ? 12 : 14,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                    popUpButtonCheckList(
                        context, state.listCheckList[index].id.toString())
                  ],
                ),
              ),
            );
          },
        );
      } else if (state is CLTStateGetFailLoad) {
        return Container(
            alignment: Alignment.centerLeft,
            child: _textBoxCheck(context, clickTask.idTask)
            // CheckboxListTile(
            //     value: checkBoxClick,
            //     onChanged: _onCheckBoxClick,
            //     controlAffinity: ListTileControlAffinity.leading,
            //     title: _textBoxCheck(context, clickTask.idTask)),
            );
      } else if (state is CLTStateAddSuccessLoad) {
        BlocProvider.of<CLTBloc>(context)
            .add(LoadAllCLTEvent(clickTask.idTask.toString()));
      } else if (state is CLTStateDeleteSuccessLoad) {
        BlocProvider.of<CLTBloc>(context)
            .add(LoadAllCLTEvent(clickTask.idTask.toString()));
      } else if (state is CLTStateEditSuccessLoad) {
        BlocProvider.of<CLTBloc>(context)
            .add(LoadAllCLTEvent(clickTask.idTask.toString()));
      }
      return Container();
    });
  }

  Widget buildCommentSection(Size size, TaskModel clickTask) {
    List<CommentModel> comments;

    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentStateGetSuccessLoad) {
          comments = state.comment;
        } else if (state is CommentStateAddSuccessLoad ||
            state is CommentStateUpdateSuccessLoad ||
            state is CommentStateDeleteSuccessLoad) {
          BlocProvider.of<CommentBloc>(context)
              .add(LoadAllCommentEvent(clickTask.idTask.toString()));
        } else if (state is CommentStateLoading) {
          return CircularProgressIndicator();
        }
        return comments == null || comments.length == 0
            ? Center(
                child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "No comment yet.",
                  style: TextStyle(
                      color: colorPrimary, fontWeight: FontWeight.bold),
                ),
              ))
            : ListView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CommentBox(
                      commentModel: comments[index],
                      size: size,
                      comment: comments[index].content,
                      user: comments[index].nameUser,
                      date: util.dateNumbertoCalendar(comments[index].date) +
                          " at " +
                          util.hourFormat(comments[index].date));
                });
      },
    );
  }

  Widget _textBoxCheck(context, int taskId) {
    return PostBox(
        pp: false,
        hint: "Add a checklist ...",
        onPost: () {
          if (textAddCheckBox.text != "") {
            BlocProvider.of<CLTBloc>(context)
                .add(AddCLTEvent(taskId.toString(), textAddCheckBox.text));
            setState(() {
              textAddCheckBox.text = "";
            });
          }
        },
        size: size,
        textEditController: textAddCheckBox);
  }

  //TO make alertdialog for picture preview
  Widget _buildCupertino({BuildContext context, String link}) {
    return new CupertinoAlertDialog(
      title: new Text("task_text13".tr()),
      content: Image.network("https://api-zukses.yokesen.com/${link}"),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "Close",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ],
    );
  }

  //Widget for PopUp BUtton in CheckList Task
  Widget popUpButtonCheckList(BuildContext context, String idCheckList) {
    return PopupMenuButton<int>(
      onSelected: (val) {
        switch (val) {
          case 1:
            FocusScope.of(context).unfocus();
            showDialog(
                context: context,
                builder: (context) => _buildCupertinoEditCheckList(
                    context: context, idCheckList: idCheckList));
            break;
          case 2:
            FocusScope.of(context).unfocus();
            BlocProvider.of<CLTBloc>(context).add(DeleteCLTEvent(idCheckList));
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "Edit Name",
            style: TextStyle(color: colorPrimary, fontWeight: FontWeight.w700),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            "Delete",
            style: TextStyle(color: colorError, fontWeight: FontWeight.w700),
          ),
        ),
      ],
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: colorBackground, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.ellipsisH,
            color: colorPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoEditCheckList(
      {BuildContext context, String idCheckList}) {
    return new CupertinoAlertDialog(
      title: new Text(
        "Edit Your CheckList Name",
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: colorNeutral2)),
        child: CupertinoTextField(
          controller: textEditCheckList,
          style: TextStyle(fontSize: 16, height: 1.0),
          textInputAction: TextInputAction.next,
          placeholder: "New Name",
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("cancel_text".tr(),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: colorError)),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        CupertinoDialogAction(
            child: Text(
              "Edit",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (textEditCheckList.text != null ||
                  textEditCheckList.text != "") {
                BlocProvider.of<CLTBloc>(context)
                    .add(EditCLTEvent(idCheckList, textEditCheckList.text));
                Navigator.pop(context, true);
              }
            }),
      ],
    );
  }

  // --------------------------Logic-----------------------------//
  bool doneLabel = false;
  // Bloc Listener getter
  List<BlocListener> listeners() => [
        BlocListener<LabelTaskBloc, LabelTaskState>(
          listener: (context, state) {
            if (state is LabelTaskStateSuccessLoad) {
              labelList.clear();
              //labelList.add("Click Here for Label");
              //print("labelTask legth ${state.labelTask.length}");
              setState(() {
                label = state.labelTask;
                state.labelTask.forEach((element) {
                  labelList.add(element.name);
                  print(element.name);
                });
                doneLabel = true;
              });
            } else if (state is LabelTaskStateFailLoad) {
              setState(() {
                //freeLabel = true;
              });
              labelList.clear();
            } else if (state is LabelTaskAddStateSuccessLoad) {
              BlocProvider.of<LabelTaskBloc>(context)
                  .add(LoadAllLabelTaskEvent());
            }
          },
        ),
        BlocListener<ChangeTaskBloc, ChangeTaskState>(
          listener: (context, state) {
            if (state is ChangeTaskStateDropdownSuccessLoad) {
              setState(() {
                isLoading = true;
              });
              BlocProvider.of<TaskBloc>(context)
                  .add(GetAllTaskEvent(projectId: widget.project.id));
            }
          },
        ),
        BlocListener<UploadAttachBloc, UploadAttachState>(
          listener: (context, state) {
            if (state is UploadAttachStateSuccess) {
              setState(() {
                upload = true;
              });
            }
          },
        ),
        BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskStateSuccessLoad) {
              setState(() {
                isLoading = false;
                lengthTask = state.task.length;
              });
              taskToDo.clear();
              taskInProgress.clear();
              taskDone.clear();
              state.task.forEach((element) {
                //print("LAbel in Task" + element.label.toString());
                if (widget.task == element.idTask) {
                  _setDataTask(element);

                  if (doneLabel) {
                    _animationController.forward();
                  }
                }
                if (element.taskType.toLowerCase() == "to-do") {
                  taskToDo.add(element);
                } else if (element.taskType.toLowerCase() == "in-progress") {
                  taskInProgress.add(element);
                } else if (element.taskType.toLowerCase() == "done") {
                  taskDone.add(element);
                }
              });
              dataTask = List.generate(3, (index) {
                if (index == 0) {
                  return taskToDo;
                } else if (index == 1) {
                  return taskInProgress;
                }
                return taskDone;
              });
            } else if (state is TaskStateAddSuccessLoad) {
              setState(() {
                isLoading = true;
              });
              BlocProvider.of<TaskBloc>(context)
                  .add(GetAllTaskEvent(projectId: widget.project.id));
            } else if (state is TaskStateFailLoad) {
              setState(() {
                isLoading = false;
              });
            } else if (state is TaskStateUpdateSuccess) {
              setState(() {
                isLoading = true;
              });
              BlocProvider.of<TaskBloc>(context)
                  .add(GetAllTaskEvent(projectId: widget.project.id));
            }
          },
        ),
      ];

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imagePicker();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imagePickerCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.file_present),
                    title: new Text('Other Files'),
                    onTap: () {
                      _filePicker();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.cancel),
                    title: new Text('cancel_text').tr(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  _filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      //allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      _uploadAttachment(file);
    }
  }

  _imagePicker() async {
    //ImagePicker for gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // final listPickedFile = await picker.pickMultiImage();
    // if (listPickedFile != null) {
    //   for (int i = 0; i < listPickedFile.length; i++) {
    //     setState(() {
    //       data = listPickedFile[i].path;
    //       print(data);
    //       _uploadAttachment(File(data));
    //     });
    //   }
    // }

    if (pickedFile != null) {
      setState(() {
        data = pickedFile.path;
        print(data);
        _uploadAttachment(File(data));
      });
    }
  }

  _imagePickerCamera() async {
    //ImagePicker for Camera
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 85);

    if (pickedFile != null) {
      setState(() {
        data = pickedFile.path;
        print(data);
        _uploadAttachment(File(data));
      });
    }
  }

  _changeProgressbyDropdown(String progress, String idTask) {
    BlocProvider.of<ChangeTaskBloc>(context)
        .add(ChangeTaskUpdateByDropdownEvent(idTask, progress));
  }

  _changeProgress(String progress, String idTask) {
    BlocProvider.of<ChangeTaskBloc>(context)
        .add(ChangeTaskUpdateEvent(idTask, progress));
  }

  void dataIndex(int outerIndex) {
    if (outerIndex == 0) {
      setState(() {
        name = "task_text5".tr();
      });
    } else if (outerIndex == 1) {
      setState(() {
        name = "task_text6".tr();
      });
    } else {
      setState(() {
        name = "task_text7".tr();
      });
    }
  }

  _buildList(int outerIndex) {
    var innerList = dataTask[outerIndex];
    dataIndex(outerIndex);
    return DragAndDropList(
      header: Container(
        width: size.width,
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
        priority: item.priority,
        label: item.label == null ? "" : item.label,
        size: size,
        title: item.taskName,
        detail: item.details,
        date: util.yearFormat(DateTime.parse(item.date)),
        hour: util.hourFormat(DateTime.parse(item.date)),
        index: index,
        onClick: () {
          _setDataTask(item);
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

  _setDataTask(TaskModel item) {
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
      data = "";
      upload = false;
      clickTask = item;
      chooseLabel = item.label;
      priority = item.priority.titleCase;
    });
    BlocProvider.of<CommentBloc>(context)
        .add(LoadAllCommentEvent(item.idTask.toString()));
    BlocProvider.of<CLTBloc>(context)
        .add(LoadAllCLTEvent(item.idTask.toString()));
    BlocProvider.of<UploadAttachBloc>(context)
        .add(UploadAttachGetEvent(item.idTask.toString()));
    _onClickItem(item);
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

  _clickDoneScroller(TaskModel clickTask) {
    _searchEnum(moveTo, clickTask.idTask.toString());

    int idLabel;
    label.forEach((element) {
      if (element.name == chooseLabel) {
        setState(() {
          idLabel = element.id;
        });
      }
    });
    if (priority != clickTask.priority ||
        idLabel != clickTask.idLabel ||
        date != DateTime.parse(clickTask.date)) {
      TaskModel taskUpdate = TaskModel(
          idTask: clickTask.idTask,
          priority: priority,
          date: date.toString(),
          idLabel: idLabel);
      BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(taskUpdate));
    }
    _animationController.reverse();
  }

  _getLabel() {
    BlocProvider.of<LabelTaskBloc>(context).add(LoadAllLabelTaskEvent());
  }

  _postComment(CommentModel comment) {
    setState(() {
      textEditingController.text = "";
    });
    BlocProvider.of<CommentBloc>(context).add(AddCommentEvent(comment));
  }

  //Function for  checking if the progress has been changed or not.
  _searchEnum(String moving, String idtask) {
    // moveToList is list of progress in front end.
    // dbEnum is list of progress in back end
    // moving is current value in moveToList.
    // mving will be checked with moveToList to get its index.
    // The gotten index will checked again with historyMOveTO from DB.
    // if it is same, it won't trigger the process, if it's different it will
    // trigger process for change progress in database.

    for (int i = 0; i < moveToList.length; i++) {
      if (moving == moveToList[i]) {
        if (dbEnum[i] != historyMoveTo) {
          _changeProgressbyDropdown(dbEnum[i], idtask);
        }
      }
    }
  }

  _uploadAttachment(File image) {
    BlocProvider.of<UploadAttachBloc>(context)
        .add(UploadAttachNewEvent(clickTask.idTask.toString(), image));
  }

  //Widget to pick dateTime in ScrollerSheet
  dateUpdatePicker(DateTime initDate, TimeOfDay initTime) async {
    final DateTime datePicked = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (datePicked != null) {
      final TimeOfDay timePicked =
          await showTimePicker(context: context, initialTime: initTime);
      if (timePicked != null) {
        setState(() {
          date = DateTime(datePicked.year, datePicked.month, datePicked.day,
              timePicked.hour, timePicked.minute);
        });
      }
    }
  }

  int dateCalculationforLateness(String date) {
    DateTime dateTask = DateTime.parse(date);
    DateTime now = DateTime.now();
    DateTime dueDate = DateTime(dateTask.year, dateTask.month, dateTask.day);
    DateTime nowDay = DateTime(now.year, now.month, now.day);
    int dif = dueDate.difference(nowDay).inDays;
    if (dif > 0)
      return 0;
    else if (dif < 0)
      return 2;
    else
      return 1;
  }
}
