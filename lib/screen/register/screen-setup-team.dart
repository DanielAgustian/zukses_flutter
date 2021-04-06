import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:clipboard/clipboard.dart';

class SetupTeam extends StatefulWidget {
  SetupTeam({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SetupTeamScreen createState() => _SetupTeamScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SetupTeamScreen extends State<SetupTeam> {
  final textLink = TextEditingController();
  final textInvEmail = TextEditingController();
  final data = "https://api-zukses.yokesen.com/api/user-attendance/3/2021";
  bool errorInvEmail = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinkTeam();
  }

  void getLinkTeam() {
    textLink.text = data;
  }

  void goTo() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RegisApproved()));
  }

  void copyLink() {
    FlutterClipboard.copy(textLink.text)
        .then((value) => print("copy:" + textLink.text));
  }

  void sentInvitation() {
    if (textInvEmail.text == "" || textInvEmail.text.length < 1) {
      setState(() {
        errorInvEmail = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(textInvEmail.text)) {
        setState(() {
          errorInvEmail = false;
        });
      } else {
        setState(() {
          errorInvEmail = true;
        });
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
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TitleFormat(
                    size: size,
                    title: "Set Up Your Team",
                    detail: "",
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Copy this link and share it to your team mates",
                style: TextStyle(
                    color: colorNeutral3,
                    fontSize: size.height < 569 ? 14 : 16),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * 0.65,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: colorBorder),
                          color: colorBackground,
                          boxShadow: [boxShadowStandard],
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextFormField(
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {},
                          controller: textLink,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              hintText: "htttp://///",
                              hintStyle: TextStyle(
                                color: colorNeutral1,
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        copyLink();
                      },
                      child: Container(
                          width: size.width * 0.2,
                          height: 50,
                          decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "Copy",
                              style: TextStyle(
                                  fontSize: size.height < 569 ? 12 : 14,
                                  color: colorBackground,
                                  fontWeight: FontWeight.bold),
                            ),
                          )))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Or use email address",
                style: TextStyle(
                    color: colorNeutral3,
                    fontSize: size.height < 569 ? 14 : 16),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: size.width * 0.92,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: errorInvEmail ? colorError : colorBorder),
                      color: colorBackground,
                      boxShadow: [boxShadowStandard],
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {},
                      controller: textInvEmail,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "Enter email here",
                          hintStyle: TextStyle(
                            color: errorInvEmail ? colorError : colorNeutral2,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              LongButton(
                size: size,
                title: "Send invitation",
                bgColor: colorPrimary,
                textColor: colorBackground,
                onClick: () {
                  sentInvitation();
                },
              ),
              SizedBox(
                height: 15,
              ),
              LongButtonOutline(
                size: size,
                outlineColor: colorPrimary,
                bgColor: colorBackground,
                textColor: colorPrimary,
                onClick: () {
                  goTo();
                },
                title: "Skip for Now",
              )
            ],
          ),
        ),
      ),
    );
  }
}
