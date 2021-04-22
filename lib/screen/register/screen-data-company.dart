import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-event.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/bussiness-scope-state.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-event.dart';
import 'package:zukses_app_1/bloc/company-profile/company-state.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/business-scope-model.dart';
import 'package:zukses_app_1/model/company-model.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';

class DataCompany extends StatefulWidget {
  DataCompany({Key key, this.title, this.token, this.paketID})
      : super(key: key);
  final String title;
  final String token;
  final String paketID;
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
  bool _nameValidator = false;
  bool _emailValidator = false;
  bool _phoneValidator = false;
  bool _addressValidator = false;
  bool _websiteValidator = false;
  bool _scopeValidator = false;
  String textItem = "";
  String idScope = "";
  bool error = false;
  bool isLoading = true;
  List<String> bussinessScope = [];
  List<BussinessScopeModel> scopeData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BussinessScopeBloc>(context)
        .add(LoadAllBussinessScopeEvent());
    print("Token = " + widget.token);
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
        setState(() {
          _emailValidator = false;
        });
      } else {
        setState(() {
          _emailValidator = true;
        });
      }
    } else {
      setState(() {
        _emailValidator = true;
      });
    }
    if (textAddress.text != "") {
      setState(() {
        _addressValidator = false;
      });
    } else {
      setState(() {
        _addressValidator = true;
      });
    }
    if (textName.text != "") {
      setState(() {
        _nameValidator = false;
      });
    } else {
      setState(() {
        _nameValidator = true;
      });
    }
    if (textPhone.text != "") {
      setState(() {
        _phoneValidator = false;
      });
    } else {
      setState(() {
        _phoneValidator = true;
      });
    }
    if (textItem != "" && textItem != null) {
      setState(() {
        _scopeValidator = false;
      });
    } else {
      setState(() {
        _scopeValidator = true;
      });
    }
    if (textWebsite.text != "") {
      setState(() {
        _websiteValidator = false;
      });
    } else {
      setState(() {
        _websiteValidator = true;
      });
    }
    /*if (textWebsite.text != "") {
      _errorFalse();
    } else {
      _errorTrue();
    }*/
    if (!_addressValidator &&
        !_emailValidator &&
        !_nameValidator &&
        !_phoneValidator &&
        !_scopeValidator &&
        !_websiteValidator) {
      _searchIDScope(textItem);
      CompanyModel model = CompanyModel(
          name: textName.text,
          phone: textPhone.text,
          email: textEmail.text,
          website: textWebsite.text,
          address: textAddress.text,
          packageId: widget.paketID);
      print("Data is Completed");
      _registerNewCompany(model);
    }
  }

  _registerNewCompany(CompanyModel model) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => _buildCupertino(
            context: context,
            wData: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email: " + model.email),
                Text("Name: " + model.name),
                Text("Phone: " + model.phone),
                Text("Website:" + model.website),
                Text("Address:" + model.address),
                Text("Scope: " + textItem),
              ],
            )));
    if (result!=null) {
      if(result){
        BlocProvider.of<CompanyBloc>(context).add(AddCompanyEvent(
          companyModel: model, token: widget.token, scope: idScope));
      }
      
    }
  }

  _searchIDScope(String textItem) {
    scopeData.forEach((element) {
      if (textItem == element.name) {
        setState(() {
          idScope = element.id.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocListener<BussinessScopeBloc, BussinessScopeState>(
              listener: (context, state) {
                if (state is BussinessScopeStateSuccessLoad) {
                  setState(() {
                    textItem = state.bussinessScope[0].name;
                  });
                  setState(() {
                    scopeData.clear();
                    scopeData.addAll(state.bussinessScope);
                  });

                  state.bussinessScope.forEach((element) {
                    bussinessScope.add(element.name);
                  });
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Container(),
            ),
            BlocListener<CompanyBloc, CompanyState>(
                listener: (context, state) {
                  if (state is AddCompanyStateSuccessLoad) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisApproved()),
                        (route) => false);
                  }
                },
                child: Container()),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical),
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
                                  color:
                                      _nameValidator ? colorError : colorBorder,
                                  width: 1),
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textName,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                labelText: "Legal Name (Required)",
                                labelStyle: TextStyle(
                                  color: _nameValidator
                                      ? colorError
                                      : colorNeutral2,
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
                                  color: _phoneValidator
                                      ? colorError
                                      : colorBorder,
                                  width: 1),
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textPhone,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                labelText: "Company Phone (Required)",
                                labelStyle: TextStyle(
                                  color: _phoneValidator
                                      ? colorError
                                      : colorNeutral2,
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
                                  color: _emailValidator
                                      ? colorError
                                      : colorBorder,
                                  width: 1),
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textEmail,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                labelText: "Company Email (Required)",
                                labelStyle: TextStyle(
                                  color: _emailValidator
                                      ? colorError
                                      : colorNeutral2,
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
                              border: Border.all(
                                  color: _websiteValidator
                                      ? colorError
                                      : colorBorder,
                                  width: 1),
                              color: colorBackground,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onChanged: (val) {},
                            controller: textWebsite,
                            decoration: InputDecoration(
                                labelText: "Company Website(Required)",
                                labelStyle: TextStyle(
                                  color: _websiteValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
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
                                  color: _addressValidator
                                      ? colorError
                                      : colorBorder,
                                  width: 1),
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
                                  color: _addressValidator
                                      ? colorError
                                      : colorNeutral2,
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
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
                              border: Border.all(
                                  color: _scopeValidator
                                      ? colorError
                                      : colorBorder),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      labelStyle: TextStyle(fontSize: 12),
                                      errorStyle: TextStyle(
                                          color: colorError, fontSize: 16.0),
                                      hintText: 'Your Bussiness Scope',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCupertino({BuildContext context, Widget wData}) {
    Size sizeDialog = MediaQuery.of(context).size;
    return new CupertinoAlertDialog(
      title: new Text(
        "Are you sure to register your company with this data?",
      ),
      content: wData,
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "Yes",
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        CupertinoDialogAction(
            child: Text(
              "No",
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            })
      ],
    );
  }
}
