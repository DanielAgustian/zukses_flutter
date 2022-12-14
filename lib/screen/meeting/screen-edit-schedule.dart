import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/avatar/avatar-medium.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/component/button/button-long-icon.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/schedule/user-invitation-item.dart';
import 'package:zukses_app_1/model/schedule-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:recase/recase.dart';
import 'package:easy_localization/easy_localization.dart';

class EditScheduleScreen extends StatefulWidget {
  final ScheduleModel model;

  const EditScheduleScreen({Key key, this.model}) : super(key: key);
  @override
  _EditScheduleScreenState createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textTitle = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  bool _titleValidator = false;
  bool _descriptionValidator = false;

  // Search controlerr
  TextEditingController textSearch = new TextEditingController();
  String searchQuery = "";

  // formater for showing date
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  DateTime date = DateTime.now();
  TimeOfDay time1 = TimeOfDay.now();
  TimeOfDay time2;
  List<UserModel> listUser = [];
  List<bool> checklistdata = [];
  List<String> choosedUser = [];
  bool getDataDone = false;
  bool _timeValidator = false;
  // time 1 and time 2
  DateTime startMeeting;
  DateTime endMeeting;
  String myId = "";
  bool loadingData = false;
  // Dropdown menu
  List<String> items = [
    "apply_leaves_text9".tr(),
    "apply_leaves_text10".tr(),
    "apply_leaves_text11".tr(),
    "Every Two Weeks",
    "Every Year"
  ];
  String repeat = "apply_leaves_text9".tr();

  // Dragable scroll controller
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 800);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  //INIT Employee BLOC
  EmployeeBloc _employeeBloc;
  List<bool> boolEmployee = [];
  // handle loading when click done
  bool loadingAdd = false;

  @override
  void initState() {
    super.initState();
    _loadAllAsyncMethod();
    // getListUser();
    // init employee bloc
    _employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    _employeeBloc.add(LoadAllEmployeeEvent());

    _controller = AnimationController(vsync: this, duration: _duration);
    setState(() {
      textTitle.text = widget.model.title;
      textDescription.text = widget.model.description;
      date = widget.model.date;
      String repeatAPI = widget.model.repeat;
      if (repeatAPI == "everytwoweeks") {
        repeat = items[3];
      } else if (repeatAPI == "everyyear") {
        repeat = items[4];
      } else if (repeatAPI == "") {
        repeat = items[0];
      } else {
        repeat = repeatAPI.titleCase;
      }

      time1 = TimeOfDay(
          hour: widget.model.date.hour, minute: widget.model.date.minute);
      time2 = TimeOfDay(
          hour: widget.model.meetingEndTime.hour,
          minute: widget.model.meetingEndTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // formater to split the hours,
    // eg. avoid when 01.01 => 1.1
    // It should be 01.01
    String h1 = (time1.hour <= 9) ? "0${time1.hour}" : time1.hour.toString();
    String m1 =
        (time1.minute <= 9) ? "0${time1.minute}" : time1.minute.toString();
    String h2 = (time2.hour <= 9) ? "0${time2.hour}" : time2.hour.toString();
    String m2 =
        (time2.minute <= 9) ? "0${time2.minute}" : time2.minute.toString();

    return WillPopScope(
      onWillPop: () {
        if (textDescription.text != "" || textTitle.text != "")
          return _onWillPop(size: size);
        return Future.value(true);
      },
      child: Scaffold(
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Repeat : " + repeat);
            print("Repeat List:" + items.toString());
          },
        ),*/
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorBackground,
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorPrimary,
            ),
            onPressed: () {
              if (textDescription.text != "" || textTitle.text != "")
                _onWillPop(size: size);
              else
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            (ScreenTab(index: 3))));
            },
          ),
          centerTitle: true,
          title: Text(
            "Edit Schedule",
            style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: size.height <= 569 ? 18 : 22),
          ),
          actions: [
            Center(
              child: InkWell(
                onTap: () {
                  addMeeting();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "done_text".tr(),
                    style: TextStyle(
                        fontSize: size.height <= 569 ? 15 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: colorBackground,
        body: BlocListener<MeetingBloc, MeetingState>(
          listener: (context, state) {
            if (state is MeetingStateUpdateSuccess) {
              Navigator.pop(context, true);
            } else if (state is MeetingStateUpdateFailed) {
              Util().showToast(
                  msg: "Something Wrong !",
                  color: colorError,
                  context: this.context,
                  txtColor: colorBackground);
              setState(() {
                loadingAdd = false;
              });
            } else if (state is MeetingStateSuccess) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ScreenTab(index: 3)));
            } else if (state is MeetingStateFail) {
              Util().showToast(
                  msg: "Delete Failed!",
                  color: colorError,
                  context: this.context,
                  txtColor: colorBackground);
              setState(() {
                loadingAdd = false;
              });
            }
          },
          child: Stack(
            children: [
              BlocListener<EmployeeBloc, EmployeeState>(
                listener: (context, state) {
                  if (state is EmployeeStateSuccessLoad) {
                    setState(() {
                      listUser = state.employees;
                      boolEmployee = state.checklist;
                    });
                    for (int i = 0; i < choosedUser.length; i++) {
                      for (int j = 0; j < state.employees.length; j++) {
                        if (choosedUser[i] == state.employees[j].userID) {
                          setState(() {
                            boolEmployee[j] = true;
                          });
                        }
                      }
                    }

                    setState(() {
                      loadingData = true;
                    });
                  }
                },
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: paddingVertical),
                child: Container(
                  color: colorBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                border: _titleValidator
                                    ? Border.all(color: colorError)
                                    : Border.all(color: Colors.transparent),
                                color: colorBackground,
                                boxShadow: [boxShadowStandard],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.streetAddress,
                              onChanged: (val) {},
                              controller: textTitle,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "title_text".tr(),
                                  hintStyle: TextStyle(
                                    color: _titleValidator
                                        ? colorError
                                        : colorNeutral2,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal),
                          child: Container(
                            decoration: BoxDecoration(
                                border: _descriptionValidator
                                    ? Border.all(color: colorError)
                                    : Border.all(color: Colors.transparent),
                                color: colorBackground,
                                boxShadow: [boxShadowStandard],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              maxLines: 8,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              onChanged: (val) {},
                              controller: textDescription,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  hintText: "task_text20".tr(),
                                  hintStyle: TextStyle(
                                    color: _descriptionValidator
                                        ? colorError
                                        : colorNeutral2,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  _selectDate(this.context);
                                },
                                child: AddScheduleRow(
                                  fontSize: size.height <= 569 ? 14 : 16,
                                  title: "date_text".tr(),
                                  textItem: "${formater.format(date)}",
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  pickTime(this.context, index: 1);
                                  //pickTime(this.context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: colorBackground,
                                      border: Border.all(
                                          color: _timeValidator
                                              ? colorError
                                              : colorBackground)),
                                  child: AddScheduleRow(
                                    fontSize: size.height <= 569 ? 14 : 16,
                                    title: "start_time_text".tr(),
                                    textItem: "$h1.$m1",
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  //pickTime(this.context, index: 2);
                                  pickTime(this.context, index: 2);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: colorBackground,
                                      border: Border.all(
                                          color: _timeValidator
                                              ? colorError
                                              : colorBackground)),
                                  child: AddScheduleRow(
                                    fontSize: size.height <= 569 ? 14 : 16,
                                    title: "end_time_text".tr(),
                                    textItem: "$h2.$m2",
                                  ),
                                ),
                              ),
                              AddScheduleRow2(
                                fontSize: size.height <= 569 ? 14 : 16,
                                title: "schedule_text4".tr(),
                                textItem: repeat,
                                items: items,
                                onSelectedItem: (val) {
                                  setState(() {
                                    repeat = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "schedule_text5".tr(),
                                  style: TextStyle(
                                      fontSize: size.height <= 569 ? 14 : 16,
                                      color: colorPrimary),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ////
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal),
                          child: LongButtonIconShadow(
                            size: size,
                            title: "schedule_text6".tr(),
                            bgColor: colorBackground,
                            textColor: colorPrimary,
                            iconWidget: FaIcon(
                              FontAwesomeIcons.plusCircle,
                              color: colorPrimary,
                            ),
                            onClick: () {
                              showModalResult(size);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal),
                          child: LongButtonOutline(
                              size: size,
                              title: "schedule_text7".tr(),
                              bgColor: colorBackground,
                              textColor: colorError,
                              outlineColor: colorError,
                              onClick: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => _buildPopupClockOut(
                                        context,
                                        size: size));
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<EmployeeBloc, EmployeeState>(
                          builder: (context, state) {
                            if (state is EmployeeStateSuccessLoad) {
                              return Container(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: choosedUser.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                  ),
                                  itemBuilder: (context, index) {
                                    // If user has been choos attendance
                                    if (choosedUser.length != 0) {
                                      for (var i = 0;
                                          i < state.employees.length;
                                          i++) {
                                        if (state.employees[i].userID ==
                                            choosedUser[index]) {
                                          return Column(
                                            children: [
                                              AvatarMedium(
                                                imgUrl:
                                                    "https://api-zukses.yokesen.com/${state.employees[i].imgUrl}",
                                              ),
                                              Text(
                                                "${state.employees[i].name}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: colorPrimary,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                    }
                                    return SizedBox();
                                  },
                                ),
                              );
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              if (loadingAdd)
                BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.white.withOpacity(0),
                    child: Column(
                      children: [
                        SizedBox(height: 200),
                        CircularProgressIndicator(
                          backgroundColor: colorPrimary70,
                          valueColor: AlwaysStoppedAnimation(colorBackground),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Add meeting . .".tr(),
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Show modal detail
  Future<void> showModalResult(Size size) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setStateModal) {
            return DraggableScrollableSheet(
              maxChildSize: 0.9,
              initialChildSize: 0.9,
              minChildSize: 0.6,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: colorNeutral2)
                      ],
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
                              Navigator.pop(context);
                            },
                            child: Text(
                              "cancel_text".tr(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height < 600
                                          ? 14
                                          : 16,
                                  color: colorPrimary),
                            ),
                          ),
                          Text(
                            "schedule_text6".tr(),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height < 600
                                        ? 18
                                        : 20,
                                color: colorPrimary,
                                fontWeight: FontWeight.w700),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "done_text".tr(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height < 600
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
                            // Search Function
                            setStateModal(() {
                              searchQuery = val;
                            });
                          },
                          controller: textSearch,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
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
                      loadingData
                          ? Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: listUser.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (textSearch.text == "" ||
                                      textSearch.text == null) {
                                    return UserInvitationItem(
                                      val: boolEmployee[index],
                                      title: listUser[index].name,
                                      imgURL:
                                          "https://api-zukses.yokesen.com/${listUser[index].imgUrl}",
                                      checkboxCallback: (val) {
                                        setStateModal(() {
                                          boolEmployee[index] =
                                              !boolEmployee[index];
                                        });

                                        // If user is checked, add to list choosed User
                                        if (boolEmployee[index]) {
                                          setState(() {
                                            choosedUser
                                                .add(listUser[index].userID);
                                          });

                                          // If uncheck, remove from the list
                                        } else {
                                          setState(() {
                                            choosedUser
                                                .remove(listUser[index].userID);
                                          });
                                        }
                                      },
                                    );
                                  } else {
                                    // Handle for search function
                                    if (listUser[index]
                                        .name
                                        .toLowerCase()
                                        .contains(searchQuery.toLowerCase())) {
                                      return UserInvitationItem(
                                        val: boolEmployee[index],
                                        title: listUser[index].name,
                                        imgURL:
                                            "https://api-zukses.yokesen.com/${listUser[index].imgUrl}",
                                        checkboxCallback: (val) {
                                          setStateModal(() {
                                            boolEmployee[index] =
                                                !boolEmployee[index];

                                            // If user is checked, add to list choosed User
                                            if (boolEmployee[index]) {
                                              choosedUser
                                                  .add(listUser[index].userID);

                                              // If uncheck, remove from the list
                                            } else {
                                              choosedUser.remove(
                                                  listUser[index].userID);
                                            }
                                          });
                                        },
                                      );
                                    }
                                  }

                                  return Container();
                                },
                              ),
                            )
                          : Container(),
                      /*BlocBuilder<EmployeeBloc, EmployeeState>(
                        builder: (context, state) {
                          if (state is EmployeeStateSuccessLoad) {
                            print("Jumlah Employee" +
                                state.employees.length.toString());
                            return Expanded();
                          } else {}
                          return Container();
                        },
                      ),*/
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPopupClockOut(BuildContext context, {size}) {
    return new AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "schedule_text11".tr(),
            style: TextStyle(
                color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          LongButton(
            size: size,
            bgColor: colorPrimary,
            textColor: colorBackground,
            title: "yes_text".tr(),
            onClick: () {
              //LOGIC
              BlocProvider.of<MeetingBloc>(context)
                  .add(DeleteMeetingEvent(meetingID: widget.model.meetingID));
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 10,
          ),
          LongButtonOutline(
            size: size,
            bgColor: colorBackground,
            textColor: colorPrimary,
            outlineColor: colorPrimary,
            title: "no_text".tr(),
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //--------------------------Logic-----------------------------//

  // Handle if user click back using button in device not in app (usually for android)
  Future<bool> _onWillPop({size}) async {
    return (await showDialog(
            context: context,
            barrierColor: Colors.white.withOpacity(0.5),
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          "schedule_text8".tr(),
                          style: TextStyle(color: colorPrimary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButton(
                        size: size,
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        title: "schedule_text9".tr(),
                        onClick: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LongButtonOutline(
                        outlineColor: colorError,
                        size: size,
                        bgColor: colorBackground,
                        textColor: colorError,
                        title: "schedule_text10".tr(),
                        onClick: () {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        },
                      )
                    ],
                  ),
                ),
              );
            })) ??
        false;
  }

  // get calendar function
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(3500),
    );
    if (picked != null && picked != date)
      setState(() {
        date = picked;
      });
  }

  // pick time function (MUST PICKED. NOT PICKING MAKE IT CANT BE ADDED)
  void pickTime(BuildContext context, {int index = 1}) async {
    showCustomTimePicker(
        context: context,
        // It is a must if you provide selectableTimePredicate
        onFailValidation: (context) => print('Unavailable Selection'),
        initialTime: index == 1
            ? TimeOfDay(hour: time1.hour, minute: time1.minute)
            : TimeOfDay(hour: time2.hour, minute: time2.minute),
        selectableTimePredicate: (time) => time.minute % 15 == 0).then((time) {
      if (time != null) {
        if (index == 1)
          setState(() {
            time1 = time;
          });
        else if (index == 2)
          setState(() {
            time2 = time;
          });
      }
    });
  }

  void addMeeting() {
    startMeeting =
        DateTime(date.year, date.month, date.day, time1.hour, time1.minute);
    endMeeting =
        DateTime(date.year, date.month, date.day, time2.hour, time2.minute);

    if (textTitle.text == "") {
      setState(() {
        _titleValidator = true;
      });
    } else {
      setState(() {
        _titleValidator = false;
      });
    }
    if (textDescription.text == "") {
      setState(() {
        _descriptionValidator = true;
      });
    } else {
      setState(() {
        _descriptionValidator = false;
      });
    }
    int pembanding =
        (time2.hour * 60 + time2.minute) - (time1.hour * 60 + time1.minute);
    if (pembanding < 0) {
      setState(() {
        _timeValidator = true;
      });
    } else {
      setState(() {
        _timeValidator = false;
      });
    }
    if (!_descriptionValidator &&
        !_titleValidator &&
        startMeeting != null &&
        endMeeting != null &&
        !_timeValidator) {
      setState(() {
        loadingAdd = true;
      });
      String temp = repeat.replaceAll(" ", "");
      ScheduleModel meeting = ScheduleModel(
          title: textTitle.text.titleCase,
          description: textDescription.text,
          date: startMeeting,
          meetingEndTime: endMeeting,
          repeat: temp.toLowerCase(),
          userID: choosedUser);

      // call event to add meeting
      BlocProvider.of<MeetingBloc>(context).add(UpdateMeetingEvent(
          model: meeting, meetingID: widget.model.meetingID));
    }
  }

  // Search Function
  void searchFunction(String q) {
    setState(() {
      searchQuery = q;
    });
  }

  _loadAllAsyncMethod() async {
    await _getMyID();
  }

  _getMyID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = prefs.getString("myID");
    widget.model.members.forEach((element) {
      if (element.userIDSchedule != myId) {
        setState(() {
          choosedUser.add(element.userIDSchedule);
        });
      }
      print(element.userIDSchedule + ";" + myId);
    });
  }
}
