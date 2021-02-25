import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddTaskScreen createState() => _AddTaskScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AddTaskScreen extends State<AddTaskScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController textDueDate = new TextEditingController();
  TextEditingController textTime = new TextEditingController();
  TextEditingController textUsername = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  TextEditingController textAssignedTo = new TextEditingController();
  TextEditingController textPriority = new TextEditingController();
  TextEditingController textNotes = new TextEditingController();
  int count = 4;
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
            icon: Icon(Icons.arrow_back, color: colorPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Add Task",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 570 ? 22 : 25,
                color: colorPrimary),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: colorNeutral150,
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextFormField(
                        controller: textUsername,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        onChanged: (val) {},
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            hintText: "Username",
                            hintStyle: TextStyle(),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: colorNeutral150,
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      controller: textDescription,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: 5,
                      decoration: new InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          hintText: 'Description Task',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: colorNeutral150,
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      controller: textAssignedTo,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: "Assigned To..",
                          hintStyle: TextStyle(),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: colorNeutral150,
                              blurRadius: 15),
                        ],
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      controller: textPriority,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: "Priority",
                          hintStyle: TextStyle(),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: size.width * 0.45,
                        decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: colorNeutral150,
                                  blurRadius: 15),
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: textDueDate,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {},
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: FaIcon(FontAwesomeIcons.arrowDown,
                                    color: colorPrimary),
                                onPressed: () {
                                  _selectDate(context);
                                  setState(() {});
                                },
                              ),
                              hintText: "Set Due Date",
                              hintStyle: TextStyle(),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        width: size.width * 0.40,
                        decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  color: colorNeutral150,
                                  blurRadius: 15),
                            ],
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: colorNeutral150,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text("+Tag",
                            style: TextStyle(
                                color: Color.fromRGBO(14, 77, 164, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                color: colorNeutral150,
                                blurRadius: 15),
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        controller: textNotes,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 3,
                        decoration: new InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            hintText: 'Notes',
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  SmallButton(
                    bgColor: colorPrimary,
                    title: "Add Task",
                    textColor: colorBackground,
                    size: 120,
                    onClick: () {},
                  )
                ],
              )),
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
}
