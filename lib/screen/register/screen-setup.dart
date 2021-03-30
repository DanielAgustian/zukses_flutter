import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/question-format.dart';
import 'package:zukses_app_1/component/register/text-box-setup.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-pricing.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:zukses_app_1/screen/register/screen-setup-team.dart';

class SetupRegister extends StatefulWidget {
  SetupRegister({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SetupRegisterScreen createState() => _SetupRegisterScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SetupRegisterScreen extends State<SetupRegister> {
  TextEditingController textTeamName = TextEditingController();
  TextEditingController textRole = TextEditingController();
  final textCompanyCode = TextEditingController();
  List<String> roleList = ["Project Manager", "Team Leader", "Team Member"];
  List<bool> boolOrganization = [false, false];
  List<bool> boolTeam = [false, false];
  List<bool> boolOrganizationExist = [false, false];
  List<bool> boolNewCompany = [false, false];
  String textItemRole = "";
  bool clickable = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textItemRole = roleList[0];
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisApproved()));
      }
    }
    if (boolOrganization[1]) {
      //THE WANT TO CREATE AS ORGANIZATION
      if (boolOrganizationExist[1]) {
        //THEIR ORGANIZATION ISNT REGISTERED
        if (boolNewCompany[0]) {
          //THEY WANTED TO SEE THE PRICE
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Pricing()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
              color: colorBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TitleFormat(
                        size: size,
                        title: "Set Up Account",
                        detail: "",
                      ),
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
                            _clickableTrue();
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
                              boolOrganizationExist[0] = val;
                              if (boolOrganizationExist[0] == true &&
                                  boolOrganizationExist[1] == true) {
                                boolOrganizationExist[1] = false;
                              }
                            });
                            _clickableTrue();
                          },
                          click2: (val) {
                            setState(() {
                              boolOrganizationExist[1] = val;
                              if (boolOrganizationExist[0] == true &&
                                  boolOrganizationExist[1] == true) {
                                boolOrganizationExist[0] = false;
                              }
                              setState(() {
                                _clickableTrue();
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
                      goTo();
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
          hint: "e.g. Tech Squad",
        ),
        SizedBox(height: 15),
        TextDropDownSetup(
          size: size,
          question: "What's your role in the team?",
          hint: "Choose your role",
          data: roleList,
          textItem: textItemRole,
          onChanged: (String value) {
            setState(() {
              textItemRole = value;
            });
          },
        ),
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
          width: 0.9 * size.width,
          decoration: BoxDecoration(
              border: Border.all(color: colorBorder, width: 1),
              color: colorBackground,
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            onChanged: (val) {},
            controller: textCompanyCode,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: "Email",
                hintStyle: TextStyle(
                  color: colorNeutral2,
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
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
