import 'package:flutter/material.dart';
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
            "Add Schedule",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: colorPrimary),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: textUsername,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Username",
                      hintStyle: TextStyle(),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: colorBackground,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Color.fromRGBO(240, 239, 242, 1),
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
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        hintText: 'Description Task',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: textAssignedTo,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Assigned To..",
                      hintStyle: TextStyle(),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: textPriority,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Priority",
                      hintStyle: TextStyle(),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.55,
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(240, 239, 242, 1),
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
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                          hintText: "Set Due Date",
                          hintStyle: TextStyle(),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.35,
                    decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 0),
                              color: Color.fromRGBO(240, 239, 242, 1),
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
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                          hintText: "Set Time",
                          hintStyle: TextStyle(),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: colorNeutral150,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text("+Tag",
                        style: TextStyle(
                            color: Color.fromRGBO(14, 77, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                      color: colorBackground,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Color.fromRGBO(240, 239, 242, 1),
                            blurRadius: 15),
                      ],
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    controller: textNotes,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 3,
                    decoration: new InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        hintText: 'Notes',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                )),
            RaisedButton(
              onPressed: () {},
              color: colorPrimary,
              child: Text(
                "Add Task",
                style: TextStyle(
                    color: colorBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            )
          ],
        )));
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
