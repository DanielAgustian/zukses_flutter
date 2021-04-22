import 'dart:async';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/component/task/comment-box.dart';
import 'package:zukses_app_1/component/task/row-task.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/task/screen-add-task.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:zukses_app_1/util/util.dart';

class InnerList {
  final String name;
  List<String> children;
  InnerList({this.name, this.children});
}

class TaskTryScreen extends StatefulWidget {
  TaskTryScreen({Key key, this.title, this.projectName}) : super(key: key);
  final String title;
  final String projectName;
  @override
  _TaskTryScreen createState() => _TaskTryScreen();
}

/// This is the stateless widget that the main application instantiates.
class _TaskTryScreen extends State<TaskTryScreen>
    with TickerProviderStateMixin {
  //-----------------DROP DOWN LIST ELEMENT----------------------//
  var moveToList = ["To Do", "In Progress", "Done"];
  var priorityList = ["High", "Medium", "Low"];
  String priority = "";
  String moveTo = "";
  var label = "";
  var labelList = ["Front End", "Back End", "Design"];
  bool historyClick = false;
  //=======================================================//
  List<String> insertValueTodo = ["data", "Kiamat", "yokesen"];
  List<String> insertValueProgess = [
    "Kaetahuan Bodoh",
    "Kelakuan",
    "yokese312",
    "kurang ajar",
    "Kalrupadatu"
  ];
  List<String> insertValueDone = ["Kera AJaib", "Kutang"];
  int count = 4, activeIndex = 0;
  ScrollController _controller;
  List<InnerList> _lists = [];
  List<List<String>> data = [];
  AnimationController _animationController;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  bool checkBoxClick = false;
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
    data = List.generate(3, (index) {
      if (index == 0) {
        return insertValueTodo;
      } else if (index == 1) {
        return insertValueProgess;
      }
      return insertValueDone;
    });
    _lists = List.generate(3, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(10, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
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
            icon: Icon(Icons.arrow_back, color: colorPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.projectName,
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
                  MaterialPageRoute(builder: (context) => AddTaskScreen()),
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
                                    children: List.generate(data.length,
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
            scrollerSheet(),
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
    var innerList = data[outerIndex];
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

  _buildItem(String item, index) {
    return DragAndDropItem(
      child: ListTaskDetail2(
        size: size,
        title: item,
        detail: index.toString(),
        date: "19-02-2019",
        hour: "15:22",
        index: index,
        onClick: () {
          print(item);
          _onClickItem();
        },
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = data[oldListIndex].removeAt(oldItemIndex);
      data[newListIndex].insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = data.removeAt(oldListIndex);
      data.insert(newListIndex, movedList);
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

  _onClickItem() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  void _onCheckBoxClick(bool newValue) => setState(() {
        checkBoxClick = newValue;
      });

  Widget scrollerSheet() {
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
                        onTap: () {},
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
                        "Task Title",
                        style: TextStyle(
                            fontSize: 20,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Task ID",
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
                            child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Senectus in nascetur massa aliquam sollicitudin tellus. Tincidunt tellus a hac aliquam pharetra, massa laoreet. Varius adipiscing at neque venenatis quam mattis dui odio mi. Vitae euismod blandit. (Note)",
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
                              textItem:
                                  Util().changeTimeToString(TimeOfDay.now()),
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
                          TaskRowLabel(
                              fontSize: size.height <= 569 ? 12 : 14,
                              title: "Label",
                              textItem: label,
                              items: labelList,
                              onSelectedItem: (val) {
                                setState(() {
                                  label = val;
                                });
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          TaskRow2(
                              fontSize: size.height <= 569 ? 12 : 14,
                              title: "Priority",
                              textItem: priority,
                              items: priorityList,
                              onSelectedItem: (val) {
                                setState(() {
                                  priority = val;
                                });
                              }),
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
                          ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                child: CheckboxListTile(
                                  value: checkBoxClick,
                                  onChanged: _onCheckBoxClick,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text("Tile" + index.toString(),
                                      style: TextStyle(
                                          fontSize:
                                              size.height <= 569 ? 12 : 14,
                                          color: colorPrimary,
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
                            },
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
                          ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return historyClick
                                  ? CommentBox(
                                      size: size,
                                      comment:
                                          "Lorem ipsum dolor sit amet, cboboa sl anapisna pna pindo aoad n[oa k doa a[ da[on a[oa [aomd [omfn lk  kh ahbd la[ß",
                                      user: "Finley Khowira",
                                      date: "14 Jan 2021")
                                  : HistoryBox(
                                      size: size,
                                      history:
                                          "Lorem ipsum dolor sit amet, cboboa sl anapisna pna pindo aoad n[oa k doa a[ da[on a",
                                      user: "Finley Khouwira",
                                      date: DateTime.now());
                            },
                          )
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
}
