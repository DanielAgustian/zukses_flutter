import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';

class DataCompany extends StatefulWidget {
  DataCompany({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _DataCompanyScreen createState() => _DataCompanyScreen();
}

/// This is the stateless widget that the main application instantiates.
class _DataCompanyScreen extends State<DataCompany> {
  final textName = TextEditingController();
  final textEmail = TextEditingController();
  final textPhone = TextEditingController();
  final textWebsite = TextEditingController();
  final textAddress = TextEditingController();
  String textItem = "";
  bool error = false;
  List<String> bussinessScope = [
    "Choose Your Business Scope",
    "Technology",
    "Accounting",
    "Communication"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textItem = bussinessScope[0];
  }

  _errorFalse() {
    setState(() {
      error = false;
    });
  }

  _errorTrue() {
    setState(() {
      error = true;
    });
  }

  void _gotoAccepted() {
    if (textEmail.text != "") {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(textEmail.text)) {
        _errorFalse();
      } else {
        _errorTrue();
      }
    }
    if (textAddress.text != "") {
      _errorFalse();
    } else {
      _errorTrue();
    }
    if (textName.text != "") {
      _errorFalse();
    } else {
      _errorTrue();
    }
    if (textPhone.text != "") {
      _errorFalse();
    } else {
      _errorTrue();
    }
    if (textItem != "" && textItem != null && textItem != bussinessScope[0]) {
      _errorFalse();
    } else {
      _errorTrue();
    }
    /*if (textWebsite.text != "") {
      _errorFalse();
    } else {
      _errorTrue();
    }*/
    if (!error) {
      print("Data is Completed");
      /*Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegisApproved()));*/
    }
    /*if (textEmail.text != "") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegisApproved()));
    } else {
      setState(() {
        error = true;
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleFormat(
                size: size,
                title: "Company Data",
                detail:
                    "Please fill in your company data to help us setting your account",
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: error ? colorError : colorBorder, width: 1),
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textName,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      labelText: "Legal Name (Required)",
                      labelStyle: TextStyle(
                        color: error ? colorError : colorNeutral2,
                      ),
                      hintText: "Legal Name",
                      hintStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height < 569 ? 10 : 15,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: error ? colorError : colorBorder, width: 1),
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textPhone,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      labelText: "Company Phone (Required)",
                      labelStyle: TextStyle(
                        color: error ? colorError : colorNeutral2,
                      ),
                      hintText: "Company phone",
                      hintStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height < 569 ? 10 : 15,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: error ? colorError : colorBorder, width: 1),
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textEmail,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      labelText: "Company Email (Required)",
                      labelStyle: TextStyle(
                        color: error ? colorError : colorNeutral2,
                      ),
                      hintText: "Company email",
                      hintStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height < 569 ? 10 : 15,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: colorBorder, width: 1),
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textWebsite,
                  decoration: InputDecoration(
                      labelText: "Company Website",
                      labelStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Company website",
                      hintStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height < 569 ? 10 : 15,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: error ? colorError : colorBorder, width: 1),
                    color: colorBackground,
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  controller: textAddress,
                  decoration: InputDecoration(
                      labelText: "Company Address (Required)",
                      labelStyle: TextStyle(
                        color: error ? colorError : colorNeutral2,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: "Company address",
                      hintStyle: TextStyle(
                        color: colorNeutral2,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height < 569 ? 10 : 15,
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorBorder),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            labelStyle: TextStyle(fontSize: 12),
                            errorStyle:
                                TextStyle(color: colorError, fontSize: 16.0),
                            hintText: 'Your Bussiness Scope',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
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
                            items: bussinessScope.map((String value) {
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
                height: size.height < 569 ? 10 : 15,
              ),
              LongButton(
                  size: size,
                  title: "Save",
                  bgColor: colorPrimary,
                  textColor: colorBackground,
                  onClick: () {
                    _gotoAccepted();
                  }),
              SizedBox(
                height: size.height < 569 ? 5 : 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
