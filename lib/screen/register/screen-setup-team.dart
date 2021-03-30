import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';

class SetupTeam extends StatefulWidget {
  SetupTeam({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SetupTeamScreen createState() => _SetupTeamScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SetupTeamScreen extends State<SetupTeam> {
  void goTo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisApproved()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarOutside,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    title: "Set Up Account",
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: size.width * 0.7,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: colorBorder),
                          color: colorBackground,
                          boxShadow: [boxShadowStandard],
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {},
                          //controller: textUsername,
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
                  TextButton(
                      onPressed: () {},
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
                      border: Border.all(color: colorBorder),
                      color: colorBackground,
                      boxShadow: [boxShadowStandard],
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {},
                      //controller: textUsername,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "htttp://///",
                          hintStyle: TextStyle(
                            color: colorNeutral1,
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
                onClick: () {},
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
