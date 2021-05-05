import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/bloc/employee/employee-bloc.dart';
import 'package:zukses_app_1/bloc/employee/employee-event.dart';
import 'package:zukses_app_1/bloc/employee/employee-state.dart';
import 'package:zukses_app_1/bloc/label-task/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/label-task/label-task-event.dart';
import 'package:zukses_app_1/bloc/label-task/label-task-state.dart';
import 'package:zukses_app_1/bloc/task/task-bloc.dart';
import 'package:zukses_app_1/bloc/task/task-event.dart';
import 'package:zukses_app_1/bloc/task/task-state.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';

import 'package:zukses_app_1/component/schedule/user-invitation-item.dart';
import 'package:zukses_app_1/component/task/row-task.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-small.dart';

import 'package:zukses_app_1/model/label-task-model.dart';
import 'package:zukses_app_1/model/task-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:recase/recase.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key key, this.title, this.projectId}) : super(key: key);
  final String title;
  final int projectId;
  @override
  _AddTaskScreen createState() => _AddTaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AddTaskScreen extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  String textItem = "", textItemSearch, textLabel = "";
  List<String> labelList = [];
  var priorityList = ["Priority", "High", "Medium", "Low"];
  String searchQuery = "";
  //var nameList = ["Daniel Agustian", "Rusak", "DAdada", "Tada"];
  List<String> hasilMultiple = [];
  List<DropdownMenuItem> dropdownItem = [];
  List<LabelTaskModel> label = [];

  List<UserModel> allUser = [];
  List<bool> boolUser = [];

  bool waitingLabel = true;
  List<int> choosedLabel = [];

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  TextEditingController textDueDate = new TextEditingController();
  TextEditingController textTime = new TextEditingController();
  TextEditingController textTitle = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  TextEditingController textAssignedTo = new TextEditingController();
  TextEditingController textPriority = new TextEditingController();
  TextEditingController textNotes = new TextEditingController();
  final textNewLabel = TextEditingController();
  final textSearch = TextEditingController();
  Util util = Util();
  int count = 4;
  bool _titleValidator = false;
  bool _descValidation = false;
  bool _assignToValidator = false;
  bool _dateValidator = false;
  bool _timeValidator = false;
  bool _labelValidator = false;
  bool _priorityValidator = false;
  bool freeLabel = false;
  bool freeAssignTo = false;

  bool getAllUser = false;

  String myID = "";

  sharedPrefId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myID = prefs.getString("myID");
    });
    print("This is my Id" + myID);
  }

  _addNewTask() {
    print("Click here");
    if (textTitle.text != "") {
      setState(() {
        _titleValidator = false;
      });
    } else {
      setState(() {
        _titleValidator = true;
      });
    }
    print("titleValidator = " + _titleValidator.toString());
    if (textDescription.text != "") {
      setState(() {
        _descValidation = false;
      });
    } else {
      setState(() {
        _descValidation = true;
      });
    }

    if (hasilMultiple.length > 0) {
      setState(() {
        _assignToValidator = false;
      });
    } else {
      setState(() {
        _assignToValidator = true;
      });
    }
    if (textItem != priorityList.first) {
      setState(() {
        _priorityValidator = false;
      });
    } else {
      setState(() {
        _priorityValidator = true;
      });
    }
    if (textDueDate.text != "") {
      setState(() {
        _dateValidator = false;
      });
    } else {
      setState(() {
        _dateValidator = true;
      });
    }
    if (textTime.text != "") {
      setState(() {
        _timeValidator = false;
      });
    } else {
      setState(() {
        _timeValidator = true;
      });
    }

    if (textLabel != labelList[0] && textLabel != labelList.last) {
      setState(() {
        _labelValidator = false;
      });
    } else {
      setState(() {
        _labelValidator = true;
      });
    }

    print("FreeAssignTO" + freeAssignTo.toString());
    if (freeAssignTo) {
      if (!_titleValidator &&
          !_descValidation &&
          !_dateValidator &&
          !_timeValidator &&
          !_priorityValidator) {
        int idLabel;
        for (int i = 0; i < label.length; i++) {
          if (label[i].name == textLabel) {
            idLabel = label[i].id;
          }
        }
        DateTime datePush = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, _time.hour, _time.minute);
        TaskModel task = TaskModel(
          idProject: widget.projectId,
          taskName: textTitle.text.titleCase,
          details: textDescription.text,
          date: datePush.toString(),
          priority: textItem,
          notes: textNotes.text,
          label: idLabel.toString(),
        );
        BlocProvider.of<TaskBloc>(context).add(AddTaskFreeEvent(task));
      }
    } else {
      if (!_titleValidator &&
          !_descValidation &&
          !_assignToValidator &&
          !_dateValidator &&
          !_timeValidator &&
          !_labelValidator &&
          !_priorityValidator) {
        /*for (int i = 0; i < hasilMultiple.length; i++) {
          int temp = hasilMultiple[i];
          if (temp == 0) {
            idUser.add(int.parse(myID));
          } else {
            idUser.add(int.parse(allUser[temp - 1].userID));
          }
        }*/
        int idLabel;
        for (int i = 0; i < label.length; i++) {
          if (label[i].name == textLabel) {
            idLabel = label[i].id;
          }
        }
        DateTime datePush = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, _time.hour, _time.minute);
        TaskModel task = TaskModel(
          idProject: widget.projectId,
          taskName: textTitle.text.titleCase,
          details: textDescription.text,
          assignee: hasilMultiple,
          date: datePush.toString(),
          priority: textItem,
          notes: textNotes.text,
          label: idLabel.toString(),
        );
        BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(task));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    textItem = priorityList[0];
    _controller = AnimationController(vsync: this, duration: _duration);
    sharedPrefId();
    BlocProvider.of<LabelTaskBloc>(context).add(LoadAllLabelTaskEvent());
    BlocProvider.of<EmployeeBloc>(context).add(LoadAllEmployeeEvent());
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
          centerTitle: true,
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft, color: colorPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Add Task",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 570 ? 18 : 22,
                color: colorPrimary),
          ),
          actions: [
            InkWell(
              onTap: () {
                _addNewTask();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 17, 10, 0),
                child: Text(
                  "Done",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height < 570 ? 14 : 16,
                      color: colorPrimary),
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: paddingVertical),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocListener<EmployeeBloc, EmployeeState>(
                        listener: (context, state) {
                          print(state);
                          if (state is EmployeeStateFailLoad) {
                            setState(() {
                              freeAssignTo = true;
                            });
                          }
                        },
                        child: Container(),
                      ),
                      BlocListener<TaskBloc, TaskState>(
                          listener: (context, state) {
                            if (state is TaskStateAddSuccessLoad) {
                              Navigator.pop(context);
                            } else if (state is TaskStateAddFailLoad) {
                              util.showToast(
                                  context: context,
                                  msg: "Add Task Failed",
                                  duration: 3,
                                  color: colorError,
                                  txtColor: colorBackground);
                            }
                          },
                          child: Container()),
                      BlocListener<LabelTaskBloc, LabelTaskState>(
                        listener: (context, state) {
                          if (state is LabelTaskStateSuccessLoad) {
                            labelList.clear();
                            labelList.add("Click Here for Label");

                            setState(() {
                              label = state.labelTask;
                              state.labelTask.forEach((element) {
                                labelList.add(element.name);
                              });
                              labelList.add("+ New Label");
                              textLabel = labelList[0];
                              waitingLabel = false;
                            });
                          } else if (state is LabelTaskStateFailLoad) {
                            setState(() {
                              //freeLabel = true;
                            });
                            labelList.clear();
                            labelList.add("Click Here for Label");
                            labelList.add("+ New Label");
                            setState(() {
                              textLabel = labelList[0];
                              waitingLabel = false;
                            });
                            print("Data Error");
                          } else if (state is LabelTaskAddStateSuccessLoad) {
                            BlocProvider.of<LabelTaskBloc>(context)
                                .add(LoadAllLabelTaskEvent());
                          }
                        },
                        child: Container(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _titleValidator
                                    ? colorError
                                    : Colors.transparent),
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextFormField(
                            controller: textTitle,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Title",
                                hintStyle: TextStyle(
                                    color: _titleValidator
                                        ? colorError
                                        : colorNeutral2),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _descValidation
                                    ? colorError
                                    : Colors.transparent),
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: textDescription,
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          maxLines: 5,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              hintText: 'Description Task',
                              hintStyle: TextStyle(
                                  color: _descValidation
                                      ? colorError
                                      : colorNeutral2),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButtonOutline(
                        size: size,
                        title: "Assigned To",
                        onClick: () {
                          if (_controller.isDismissed) {
                            _controller.forward();
                          } else if (_controller.isCompleted) {
                            _controller.reverse();
                          }
                        },
                        bgColor: colorBackground,
                        outlineColor: colorPrimary,
                        textColor: colorPrimary,
                      ),
                      hasilMultiple.length < 1
                          ? Container()
                          : Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: hasilMultiple.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.9,
                                  crossAxisCount: 4,
                                ),
                                itemBuilder: (context, index) {
                                  // If user has been choos attendance
                                  if (hasilMultiple.length != 0) {
                                    for (var i = 0; i < allUser.length; i++) {
                                      if (allUser[i].userID ==
                                          hasilMultiple[index]) {
                                        return Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                color: colorPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                allUser[i].name,
                                                style: TextStyle(
                                                    color: colorBackground,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                color: colorPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text(
                                                "Myswlf",
                                                style: TextStyle(
                                                    color: colorBackground,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    // }
                                  }
                                  return Container();
                                },
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      RowTaskAddPriority(
                        list: priorityList,
                        textItem: textItem,
                        size: size,
                        onSelectedItem: (val) {
                          setState(() {
                            textItem = val;
                          });
                        },
                      ),
                      _priorityValidator
                          ? Text("Please Choose another priority.",
                              style: TextStyle(
                                color: colorError,
                                fontSize: 12,
                              ))
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                              width: size.height < 600
                                  ? size.width * 0.4
                                  : size.width * 0.45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _dateValidator
                                          ? colorError
                                          : Colors.transparent),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: IgnorePointer(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: textDueDate,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: FaIcon(
                                            FontAwesomeIcons.chevronDown,
                                            color: colorPrimary),
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                      ),
                                      hintText: "Set Due Date",
                                      hintStyle: TextStyle(),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              _selectTime();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: size.width * 0.40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _timeValidator
                                          ? colorError
                                          : Colors.transparent),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: IgnorePointer(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: textTime,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        icon: FaIcon(FontAwesomeIcons.clock,
                                            color: colorPrimary),
                                        onPressed: () {
                                          _selectTime();
                                        },
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 0),
                                      hintText: "Time",
                                      hintStyle: TextStyle(),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      waitingLabel
                          ? Container()
                          : RowTaskDrop(
                              list: labelList,
                              textItem: textLabel,
                              size: size,
                              onSelectedItem: (val) {
                                setState(() {
                                  textLabel = val;
                                  if (textLabel == "+ New Label") {
                                    _showPicker(context);
                                  }
                                });
                              },
                            ),
                      _labelValidator
                          ? Text("Please Choose another label.",
                              style: TextStyle(
                                color: colorError,
                                fontSize: 12,
                              ))
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          decoration: BoxDecoration(
                              color: colorBackground,
                              boxShadow: [boxShadowStandard],
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: textNotes,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 3,
                            decoration: new InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 5),
                                hintText: 'Notes',
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
            ),
            scrollerSheet()
          ],
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(selectedDate);
        textDueDate.text = formatted;
      });
  }

  TimeOfDay _time = TimeOfDay.now();
  void _selectTime() async {
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        String data = _time.format(context);
        DateTime date = DateFormat.jm().parse(data);
        String finalTime = DateFormat("HH:mm").format(date);
        textTime.text = finalTime;
      });
    }
  }

  _addNewLabel(String newLabel) async {
    BlocProvider.of<LabelTaskBloc>(context).add(AddLabelTaskEvent(newLabel));
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal, vertical: paddingVertical),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Create New Label",
                        style: TextStyle(
                            color: colorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [boxShadowStandard],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: TextFormField(
                            controller: textNewLabel,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintText: "New Label",
                                hintStyle: TextStyle(),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SmallButton(
                            bgColor: colorPrimary,
                            title: "Add",
                            textColor: colorBackground,
                            size: 120,
                            onClick: () {
                              _addNewLabel(textNewLabel.text);
                              Navigator.pop(context);
                            },
                          ),
                          SmallButton(
                            bgColor: colorError,
                            title: "Cancel",
                            textColor: colorBackground,
                            size: 120,
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }

  void searchFunction(String q) {
    setState(() {
      searchQuery = q;
    });
  }

  Widget scrollerSheet() {
    return SizedBox.expand(
      child: SlideTransition(
        position: _tween.animate(_controller),
        child: DraggableScrollableSheet(
          maxChildSize: 0.8,
          initialChildSize: 0.7,
          minChildSize: 0.4,
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
                          _controller.reverse();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height < 600
                                  ? 14
                                  : 16,
                              color: colorPrimary),
                        ),
                      ),
                      Text(
                        "Add Assignee",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height < 600
                                ? 18
                                : 20,
                            color: colorPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () {
                          _controller.reverse();
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height < 600
                                  ? 14
                                  : 16,
                              color: colorPrimary,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(240, 239, 242, 1),
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.streetAddress,
                      onChanged: (val) {
                        searchFunction(val);
                      },
                      controller: textSearch,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colorNeutral1,
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: colorNeutral1,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocListener<EmployeeBloc, EmployeeState>(
                      listener: (context, state) {
                        if (state is EmployeeStateSuccessLoad) {
                          //return showMember(scrollController, state,
                          //query: searchQuery);
                          allUser.clear();
                          boolUser.clear();
                          setState(() {
                            boolUser.add(false);
                            allUser
                                .add(UserModel(name: "Myself", userID: myID));
                            for (int i = 0; i < state.employees.length; i++) {
                              allUser.add(state.employees[i]);
                              boolUser.add(state.checklist[i]);
                            }
                            getAllUser = true;
                          });
                        } else {}
                      },
                      child: Container()),
                  getAllUser
                      ? showMember(scrollController, allUser, boolUser,
                          query: searchQuery)
                      : Container()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // List to show the member
  Widget showMember(
      ScrollController scrollController,
      //EmployeeStateSuccessLoad state,
      List<UserModel> allUser,
      List<bool> checklist,
      {String query}) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: allUser.length,
        itemBuilder: (BuildContext context, int index) {
          if (textSearch.text == "" || textSearch.text == null) {
            return UserInvitationItem(
              val: checklist[index],
              title: allUser[index].name,
              checkboxCallback: (val) {
                setState(() {
                  checklist[index] = !checklist[index];

                  // If user is checked, add to list choosed User
                  if (checklist[index]) {
                    hasilMultiple.add(allUser[index].userID);

                    // If uncheck, remove from the list
                  } else {
                    hasilMultiple.remove(allUser[index].userID);
                  }
                });
              },
            );
          } else {
            // Handle for search function
            if (allUser[index]
                .name
                .toLowerCase()
                .contains(query.toLowerCase())) {
              return UserInvitationItem(
                val: checklist[index],
                title: allUser[index].name,
                checkboxCallback: (val) {
                  setState(() {
                    checklist[index] = !checklist[index];

                    // If user is checked, add to list choosed User
                    if (checklist[index]) {
                      hasilMultiple.add(allUser[index].userID);

                      // If uncheck, remove from the list
                    } else {
                      hasilMultiple.remove(allUser[index].userID);
                    }
                  });
                },
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}
