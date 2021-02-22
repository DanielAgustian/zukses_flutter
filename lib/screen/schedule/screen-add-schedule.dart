import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/component/schedule/row-schedule.dart';
import 'package:zukses_app_1/constant/constant.dart';

// ignore: must_be_immutable
class AddScheduleScreen extends StatelessWidget {
  TextEditingController textTitle = new TextEditingController();
  TextEditingController textDescription = new TextEditingController();
  final DateFormat formater = DateFormat.yMMMMEEEEd();
  bool _titleValidator = false;
  bool _descriptionValidator = false;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
        padding: EdgeInsets.all(20),
        color: colorBackground,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    border: _titleValidator
                        ? Border.all(color: colorError)
                        : Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (val) {},
                  controller: textTitle,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: _titleValidator ? colorError : colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: _descriptionValidator
                        ? Border.all(color: colorError)
                        : Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Color.fromRGBO(240, 239, 242, 1),
                          blurRadius: 15),
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textDescription,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: "Description",
                      hintStyle: TextStyle(
                        color:
                            _descriptionValidator ? colorError : colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AddScheduleRow(
                title: "Date",
                textItem: "${formater.format(date)}",
              ),
              AddScheduleRow(
                title: "Time",
                textItem: "09.00 - 09.30",
              ),
              AddScheduleRow(
                title: "Repeat",
                textItem: "Never",
              )
            ],
          ),
        ),
      ),
    );
  }
}
