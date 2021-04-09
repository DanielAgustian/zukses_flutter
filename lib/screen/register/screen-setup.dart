import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/company-services.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-event.dart';
import 'package:zukses_app_1/bloc/company-profile/company-state.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/question-format.dart';
import 'package:zukses_app_1/component/register/text-box-setup.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/register-model.dart';
import 'package:zukses_app_1/screen/register/screen-pricing.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:zukses_app_1/screen/register/screen-setup-team.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zukses_app_1/util/util.dart';

class SetupRegister extends StatefulWidget {
  SetupRegister({Key key, this.title, this.register}) : super(key: key);
  final String title;
  final RegisterModel register;
  @override
  _SetupRegisterScreen createState() => _SetupRegisterScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SetupRegisterScreen extends State<SetupRegister> {
  TextEditingController textTeamName = TextEditingController();
  TextEditingController textRole = TextEditingController();
  final textCompanyCode = TextEditingController();
  /*List<String> companyCode = ["YTI1", "WGM", "IHY"];
  List<String> companyname = ["Yokesen", "Warisan Gajah Mada", "IHoney"];
  List<String> roleList = ["Project Manager", "Team Leader", "Team Member"];*/
  String companyCode = "";
  List<bool> boolOrganization = [false, false];
  List<bool> boolTeam = [false, false];
  List<bool> boolOrganizationExist = [false, false];
  List<bool> boolNewCompany = [false, false];
  bool teamText = false, teamDropDown = false;
  String textItemRole = "";
  String valueCode = "";
  bool clickable = false;
  int indexData = 0;
  bool searching = false, readOnly = false;
  bool stopSearching = false;
  String viewDataCompany = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _clickableTrue() {
    setState(() {
      clickable = true;
    });
  }

  _clickableFalse() {
    setState(() {
      clickable = false;
    });
  }

  _searchFunction(String query) {
    BlocProvider.of<CompanyBloc>(context).add(CompanyEventGetCode(kode: query));
  }

  _registerAccount() {
    BlocProvider.of<RegisterBloc>(context)
        .add(AddRegisterIndividuEvent(widget.register));
  }

  _catchPopPricing() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Pricing()));
    if (result == true) {
      setState(() {
        boolOrganization = [true, false];
        boolTeam = [false, true];
      });
    }
  }

  goTo() {
    if (boolOrganization[0]) {
      //THE WANT TO CREATE AS INDIVIDUAL
      if (boolTeam[0]) {
        //THEY WANT TO CREATE A TEAM
        print("TextBox Team :" + textTeamName.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SetupTeam()));
      }
      if (boolTeam[1]) {
        //THEY DONT WANTED TO CREATE A TEAM
        _registerAccount();
      }
    }
    if (boolOrganization[1]) {
      //THE WANT TO CREATE AS ORGANIZATION
      if (boolOrganizationExist[0]) {
        //THEIR ORGANIZATION IS REGISTERED

        //if they choose company code
        //Navigator.push(co);
        BlocProvider.of<RegisterBloc>(context).add(AddRegisterCompanyEvent(
            register: widget.register, kode: companyCode));
      }
      if (boolOrganizationExist[1]) {
        //THEIR ORGANIZATION ISNT REGISTERED
        if (boolNewCompany[0]) {
          //THEY WANTED TO SEE THE PRICE
          _catchPopPricing();
        }
        if (boolNewCompany[1]) {
          setState(() {
            boolOrganization = [true, false];
            boolTeam = [false, false];
            _clickableFalse();
          });
        }
      }
    }
  }

  _sharedPrefLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userLogin", widget.register.email);
    await prefs.setString("passLogin", widget.register.password);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Center(
            child: Container(
              color: colorBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterStateSuccess) {
                        if (state.authUser.where == "individu") {
                          _sharedPrefLogin();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisApproved()));
                        }
                      } else if (state is RegisterStateFailed) {
                        Util().showToast(
                            context: context,
                            duration: 3,
                            txtColor: colorBackground,
                            color: colorError,
                            msg: "Register Failed");
                      } else if (state is RegisterStateCompanySuccess) {
                        _sharedPrefLogin();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WaitRegisApproved(
                                      company: textCompanyCode.text,
                                    )));
                      } else if (state is RegisterStateCompanyFailed) {
                        Util().showToast(
                            context: context,
                            duration: 3,
                            txtColor: colorBackground,
                            color: colorError,
                            msg: "Register Company Failed");
                      }
                    },
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TitleFormat(
                      size: size,
                      title: "Set Up Account",
                      detail: "",
                    ),
                  ),
                  QuestionFormat(
                    size: size,
                    question: "How do you want to use Zukses?",
                    answer1: "As An Individual",
                    answer2: "As An Organization",
                    bool1: boolOrganization[0],
                    bool2: boolOrganization[1],
                    click1: (val) {
                      setState(() {
                        readOnly = false;
                        boolTeam = [false, false];
                        boolOrganization[0] = val;
                        if (boolOrganization[0] == true &&
                            boolOrganization[1] == true) {
                          boolOrganization[1] = false;
                        }
                      });
                      _clickableFalse();
                    },
                    click2: (val) {
                      setState(() {
                        readOnly = false;
                        boolOrganizationExist = [false, false];
                        boolNewCompany = [false, false];
                        boolOrganization[1] = val;

                        if (boolOrganization[0] == true &&
                            boolOrganization[1] == true) {
                          boolOrganization[0] = false;
                        }
                      });
                      _clickableFalse();
                    },
                  ),
                  SizedBox(height: 15),
                  boolOrganization[0]
                      ? QuestionFormat(
                          size: size,
                          question: "Do you have team?",
                          answer1: "Yes",
                          answer2: "No",
                          bool1: boolTeam[0],
                          bool2: boolTeam[1],
                          click1: (val) {
                            setState(() {
                              boolTeam[0] = val;
                              if (boolTeam[0] == true && boolTeam[1] == true) {
                                boolTeam[1] = false;
                              }
                            });
                            _clickableFalse();
                          },
                          click2: (val) {
                            setState(() {
                              boolTeam[1] = val;
                              if (boolTeam[0] == true && boolTeam[1] == true) {
                                boolTeam[0] = false;
                              }
                              setState(() {
                                _clickableTrue();
                              });
                            });
                          },
                        )
                      : Container(),
                  boolOrganization[1]
                      ? QuestionFormat(
                          size: size,
                          question:
                              "Has your organization registered in Zukses?",
                          answer1: "Yes",
                          answer2: "No",
                          bool1: boolOrganizationExist[0],
                          bool2: boolOrganizationExist[1],
                          click1: (val) {
                            setState(() {
                              boolNewCompany = [false, false];
                              boolOrganizationExist[0] = val;
                              if (boolOrganizationExist[0] == true &&
                                  boolOrganizationExist[1] == true) {
                                boolOrganizationExist[1] = false;
                              }
                            });
                            _clickableFalse();
                          },
                          click2: (val) {
                            setState(() {
                              boolOrganizationExist[1] = val;
                              if (boolOrganizationExist[0] == true &&
                                  boolOrganizationExist[1] == true) {
                                boolOrganizationExist[0] = false;
                              }
                              setState(() {
                                _clickableFalse();
                              });
                            });
                          },
                        )
                      : Container(),
                  boolOrganization[0] && boolTeam[0]
                      ? teamData(context, size)
                      : Container(),
                  boolOrganization[1] && boolOrganizationExist[0]
                      ? organizationExist(context, size)
                      : Container(),
                  boolOrganization[1] && boolOrganizationExist[1]
                      ? organizationNotExist(context, size)
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  LongButtonSize(
                    clickable: clickable,
                    size: size,
                    width: 0.9 * size.width,
                    onClick: () {
                      if (clickable) {
                        goTo();
                      }
                    },
                    bgColor: clickable ? colorPrimary : colorPrimary30,
                    textColor: colorBackground,
                    title: "Set up and continue",
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //To OPEN TEAM FORM
  Widget teamData(BuildContext context, Size size) {
    return Column(
      children: [
        SizedBox(height: 15),
        TextBoxSetup(
          textBox: textTeamName,
          size: size,
          question: "What's your team called?",
          hint: "e.g. Min Word 3",
          onChanged: (val) {
            if (val.length > 3) {
              setState(() {
                teamText = true;
              });
              _clickableTrue();
            } else {
              setState(() {
                teamText = false;
              });
              _clickableFalse();
            }
          },
        ),
        //SizedBox(height: 15),
        /*TextDropDownSetup(
          size: size,
          question: "What's your role in the team?",
          hint: "Choose your role",
          data: roleList,
          textItem: textItemRole,
          onChanged: (String value) {
            setState(() {
              textItemRole = value;
              teamDropDown = true;
            });
            if (teamText && teamDropDown) {
              _clickableTrue();
            }
          },
        ),*/
      ],
    );
  }

  //TO OPEN TEXTFORM COMPANY CODE.
  Widget organizationExist(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        Text(
          "Input your company code",
          style: TextStyle(
              color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
        ),
        SizedBox(
          height: size.height < 569 ? 5 : 10,
        ),
        Container(
          width: size.width,
          decoration: BoxDecoration(
              border: Border.all(color: colorBorder, width: 1),
              color: readOnly ? colorNeutral170 : colorBackground,
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            readOnly: readOnly,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            onChanged: (val) {
              if (val.length >= 3) {
                print("Val.length = " + val.length.toString());
                _searchFunction(val);
                searching = true;
              } else if (val.length < 1) {
                stopSearching = false;
              }
            },
            controller: textCompanyCode,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: "Company Code",
                hintStyle: TextStyle(
                  color: colorNeutral2,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        BlocBuilder<CompanyBloc, CompanyState>(builder: (context, state) {
          if (state is CompanyCodeStateSuccessLoad) {
            if (state.company.id == "") {
              return searching
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          searching = false;
                        });
                      },
                      child: Material(
                        elevation: 20,
                        child: Container(
                          height: size.height < 569 ? 35 : 40,
                          width: size.width,
                          decoration: BoxDecoration(
                            boxShadow: [boxShadowStandard],
                          ),
                          child: Center(
                            child: Text(
                              "That code hasn't been registered.",
                              style:
                                  TextStyle(fontSize: 14, color: colorPrimary),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container();
            }
            return searching
                ? InkWell(
                    onTap: () {
                      setState(() {
                        companyCode = textCompanyCode.text;
                        searching = false;
                        textCompanyCode.text = state.company.name;
                        stopSearching = true;
                        readOnly = true;
                        _clickableTrue();
                      });
                    },
                    child: Material(
                      elevation: 20,
                      child: Container(
                        height: size.height < 569 ? 35 : 40,
                        width: size.width,
                        decoration: BoxDecoration(
                          boxShadow: [boxShadowStandard],
                        ),
                        child: Center(
                          child: Text(
                            state.company.name,
                            style: TextStyle(fontSize: 14, color: colorPrimary),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  //WIDGET FOR SOMEONE WHO DIDNT HAVE AY ORAGNIZATION AND WANTED IN ORGNAIZATION
  Widget organizationNotExist(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height < 569 ? 10 : 15,
        ),
        QuestionFormat2(
          size: size,
          question: "Do you want to register your company?",
          answer1: "Yes, show me the pricing scheme",
          answer2: "No, I want to register as free individual",
          bool1: boolNewCompany[0],
          bool2: boolNewCompany[1],
          click1: (val) {
            setState(() {
              boolNewCompany[0] = val;
              if (boolNewCompany[0] == true && boolNewCompany[1] == true) {
                boolNewCompany[1] = false;
              }
            });
            _clickableTrue();
          },
          click2: (val) {
            setState(() {
              boolNewCompany[1] = val;
              if (boolNewCompany[0] == true && boolNewCompany[1] == true) {
                boolNewCompany[0] = false;
              }
              setState(() {
                _clickableTrue();
              });
            });
          },
        ),
      ],
    );
  }
}
