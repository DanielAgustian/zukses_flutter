import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:zukses_app_1/screen/send-feedback/screen-answer-contact.dart';

class ScreenContactSupervisor extends StatefulWidget {
  ScreenContactSupervisor({this.model});
  final model;
  _ScreenContactSupervisor createState() => _ScreenContactSupervisor();
}

class _ScreenContactSupervisor extends State<ScreenContactSupervisor> {
  final textMessage = TextEditingController();

  String textItem = "";
  List<String> itemMessageType = ["Question", "Report Problem", "Report Bugs"];

  @override
  void initState() {
    super.initState();
    textItem = itemMessageType[0];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreenAnswerContact()));
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorBackground,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: colorPrimary,
              ))),
        ),
        title: Text(
          "Contact Supervisor",
          style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.bold,
              fontSize: size.height <= 600 ? 20 : 22),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Write Your Message Here",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 15,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  readOnly: true,
                  maxLines: 8,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textMessage,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      hintText: /*"apply_overtime_text5".tr()*/ "Tell the question you want to ask",
                      hintStyle: TextStyle(
                        color: colorNeutral1,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Message Type",
                style: TextStyle(
                    fontSize: size.height < 569 ? 14 : 16,
                    color: colorGoogle,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    color: colorBackground,
                    boxShadow: [
                      BoxShadow(
                        color: colorNeutral1.withOpacity(1),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 12),
                          errorStyle:
                              TextStyle(color: colorError, fontSize: 16.0),
                          hintText: 'company_text8'.tr(),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                        ),
                        isEmpty: textItem == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: textItem,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                textItem = newValue;
                              });
                            },
                            items: itemMessageType.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.centerRight,
                width: size.width,
                child: SmallButton(
                  onClick: () {},
                  title: "Send",
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
