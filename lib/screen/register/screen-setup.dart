import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/company-profile/company-bloc.dart';
import 'package:zukses_app_1/bloc/company-profile/company-event.dart';
import 'package:zukses_app_1/bloc/company-profile/company-state.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/question-format.dart';
import 'package:zukses_app_1/component/register/text-box-setup.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-pricing.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:zukses_app_1/screen/register/screen-setup-team.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:easy_localization/easy_localization.dart';

class SetupRegister extends StatefulWidget {
  SetupRegister({Key key, this.title, this.token}) : super(key: key);
  final String title;
  final String token;
  //final RegisterModel register;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<UserDataBloc>(
      create: (context) => UserDataBloc(),
      child: Scaffold(
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
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WaitRegisApproved(
                                        company: textCompanyCode.text,
                                      )),
                              (route) => false);
                        } else if (state is RegisterStateCompanyFailed) {
                          Util().showToast(
                              context: context,
                              duration: 3,
                              txtColor: colorBackground,
                              color: colorError,
                              msg: "Register Company Failed");
                        } else if (state is RegisterStateTeamSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetupTeam()));
                        }
                      },
                      child: Container(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TitleFormat(
                        size: size,
                        title: "invite_team_text1".tr(),
                        detail: "",
                      ),
                    ),
                    QuestionFormat(
                      size: size,
                      question: "setup_account_text2".tr(),
                      answer1: "setup_account_text3".tr(),
                      answer2: "setup_account_text4".tr(),
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
                          textTeamName.text = "";
                        });
                        _clickableFalse();
                      },
                    ),
                    SizedBox(height: 15),
                    boolOrganization[0]
                        ? QuestionFormat(
                            size: size,
                            question: "setup_account_text9".tr(),
                            answer1: "yes_text".tr(),
                            answer2: "no_text".tr(),
                            bool1: boolTeam[0],
                            bool2: boolTeam[1],
                            click1: (val) {
                              setState(() {
                                boolTeam[0] = val;
                                if (boolTeam[0] == true &&
                                    boolTeam[1] == true) {
                                  boolTeam[1] = false;
                                }
                              });
                              _clickableFalse();
                            },
                            click2: (val) {
                              setState(() {
                                boolTeam[1] = val;
                                if (boolTeam[0] == true &&
                                    boolTeam[1] == true) {
                                  boolTeam[0] = false;
                                }
                                setState(() {
                                  _clickableTrue();
                                  textTeamName.text = "";
                                });
                              });
                            },
                          )
                        : Container(),
                    boolOrganization[1]
                        ? QuestionFormat(
                            size: size,
                            question: "setup_account_text5".tr(),
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
                                textTeamName.text = "";
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
                                  textTeamName.text = "";
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
                      title: "setup_account_text10".tr(),
                    )
                  ],
                ),
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
          question: "setup_account_text11".tr(),
          hint: "setup_account_text12".tr(),
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
          "setup_account_text6".tr(),
          style: TextStyle(
              color: colorNeutral3, fontSize: size.height < 569 ? 14 : 16),
        ),
        SizedBox(
          height: size.height < 569 ? 5 : 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width * 0.7,
              height: 50,
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
                    hintText: "setup_account_text13".tr(),
                    hintStyle: TextStyle(
                      color: colorNeutral2,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    readOnly = false;
                    textCompanyCode.text = "";
                  });
                  _clickableFalse();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorError),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.times,
                      color: colorBackground,
                      size: size.height < 569 ? 30 : 35,
                    ),
                  ),
                ))
          ],
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
                              "invite_confirm_text3".tr(),
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
          question: "company_text9".tr(),
          answer1: "setup_account_text14".tr(),
          answer2: "setup_account_text15".tr(),
          bool1: boolNewCompany[0],
          bool2: boolNewCompany[1],
          click1: (val) {
            setState(() {
              boolNewCompany[0] = val;
              if (boolNewCompany[0] == true && boolNewCompany[1] == true) {
                boolNewCompany[1] = false;
              }
              textTeamName.text = "";
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
                textTeamName.text = "";
                _clickableTrue();
              });
            });
          },
        ),
      ],
    );
  }

  Widget _buildCupertino({BuildContext context, Widget wData}) {
    return new CupertinoAlertDialog(
      title: new Text(
        "company_text9".tr(),
      ),
      content: wData,
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "no_text".tr(),
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }),
        CupertinoDialogAction(
            child: Text(
              "yes_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ],
    );
  }

  // --------------------------Logic-----------------------------//

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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisApproved()));
  }

  _registerTeam() async {
    String data = await _makeLink();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SetupTeam(
                  link: data,
                  namaTeam: textTeamName.text,
                  token: widget.token,
                )));
  }

  _catchPopPricing() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Pricing(
                  token: widget.token,
                )));
    if (result != null) {
      if (result == true) {
        setState(() {
          boolOrganization = [true, false];
          boolTeam = [false, true];
        });
      }
    }
  }

  _registerCompany() async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => _buildCupertino(
            context: context,
            wData: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Company Code: " + companyCode),
                Text("Company Name: " + textCompanyCode.text)
              ],
            )));
    if (result) {
      BlocProvider.of<RegisterBloc>(context)
          .add(AddRegisterCompanyEvent(token: widget.token, kode: companyCode));
    }
  }

  goTo() {
    if (boolOrganization[0]) {
      //THE WANT TO CREATE AS INDIVIDUAL
      if (boolTeam[0]) {
        //THEY WANT TO CREATE A TEAM

        _registerTeam();
        print("TextBox Team :" + textTeamName.text);
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

        _registerCompany();
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

  Future<String> _makeLink() async {
    String prinitng =
        await Util().createDynamicLink(page: "registerteam", short: false);
    return prinitng;
  }
}
