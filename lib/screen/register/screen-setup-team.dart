import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zukses_app_1/bloc/register/register-bloc.dart';
import 'package:zukses_app_1/bloc/register/register-event.dart';
import 'package:zukses_app_1/bloc/register/register-state.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/component/register/title-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/register/screen-regis-approved.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';

class SetupTeam extends StatefulWidget {
  SetupTeam({Key key, this.title, this.link, this.token, this.namaTeam})
      : super(key: key);
  final String title;
  final String link;
  final String token;
  final String namaTeam;
  @override
  _SetupTeamScreen createState() => _SetupTeamScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SetupTeamScreen extends State<SetupTeam> {
  List<TextEditingController> textEmail = [];
  List<String> listEmail = [];
  final textLink = TextEditingController();
  final textInvEmail = TextEditingController();
  String data = "";
  bool errorInvEmail = false;
  int jumlahTextEditing = 0;

  @override
  void initState() {
    super.initState();
    getLinkTeam();
    data = widget.link;
    for (int i = 0; i < 4; i++) {
      textEmail.add(TextEditingController());
    }
    textLink.text = widget.link;
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
              BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterStateTeamSuccess) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisApproved()),
                          (route) => false);
                    }
                  },
                  child: Container()),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TitleFormat(
                    size: size,
                    title: "invite_team_text1".tr(),
                    detail: "",
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "invite_team_text2".tr(),
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
                              hintText: "htttp://",
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
                "invite_team_text3".tr(),
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
                      controller: textEmail[0],
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
              jumlahTextEditing > 0
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: size.width * 0.92,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: errorInvEmail
                                          ? colorError
                                          : colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  controller: textEmail[1],
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      hintText: "Enter email here",
                                      hintStyle: TextStyle(
                                        color: errorInvEmail
                                            ? colorError
                                            : colorNeutral2,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              )),
                        ],
                      ),
                    )
                  : Container(),
              jumlahTextEditing > 1
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: size.width * 0.92,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: errorInvEmail
                                          ? colorError
                                          : colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  controller: textEmail[2],
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      hintText: "Enter email here",
                                      hintStyle: TextStyle(
                                        color: errorInvEmail
                                            ? colorError
                                            : colorNeutral2,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              )),
                        ],
                      ),
                    )
                  : Container(),
              jumlahTextEditing > 2
                  ? Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: size.width * 0.92,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: errorInvEmail
                                          ? colorError
                                          : colorBorder),
                                  color: colorBackground,
                                  boxShadow: [boxShadowStandard],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onChanged: (val) {},
                                  controller: textEmail[3],
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      hintText: "Enter email here",
                                      hintStyle: TextStyle(
                                        color: errorInvEmail
                                            ? colorError
                                            : colorNeutral2,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none),
                                ),
                              )),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: size.height < 569 ? 5 : 10,
              ),
              jumlahTextEditing < 3
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          if (jumlahTextEditing <= 3) {
                            setState(() {
                              jumlahTextEditing++;
                            });
                          }
                        },
                        child: Text(
                          "invite_team_text4".tr(),
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: size.height < 569 ? 10 : 12),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              LongButton(
                size: size,
                title: "invite_team_text5".tr(),
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
                title: "invite_team_text6".tr(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertino({BuildContext context, Widget wData}) {
    return new CupertinoAlertDialog(
      title: new Text(
        "Are you sure to register your team with this data?",
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

  void getLinkTeam() {
    textLink.text = data;
  }

  void goTo() async {
    List<String> listData = [];
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) => _buildCupertino(
            context: context,
            wData: Container(
              child: Column(
                children: [
                  Text("Team Name: " + widget.namaTeam),
                ],
              ),
            )));
    if (result) {
      BlocProvider.of<RegisterBloc>(context).add(AddRegisterTeamEvent(
          namaTeam: widget.namaTeam,
          token: widget.token,
          link: widget.link,
          email: listData));
    }
  }

  void copyLink() {
    FlutterClipboard.copy(textLink.text)
        .then((value) => print("copy:" + textLink.text));
  }

  void sentInvitation() async {
    if (textInvEmail.text == "" || textInvEmail.text.length < 1) {
      setState(() {
        errorInvEmail = true;
      });
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      int temp = 0;
      while (temp <= jumlahTextEditing) {
        if (regex.hasMatch(textEmail[temp].text)) {
          setState(() {
            errorInvEmail = false;
          });
        } else {
          setState(() {
            errorInvEmail = true;
          });
        }
        temp++;
      }
    }

    setState(() {
      errorInvEmail = false;
    });

    if (errorInvEmail == false) {
      for (int i = 0; i <= jumlahTextEditing; i++) {
        listEmail.add(textEmail[i].text);
      }
      var result = await showDialog(
          context: context,
          builder: (BuildContext context) => _buildCupertino(
              context: context,
              wData: Container(
                child: Column(
                  children: [
                    Text("Team Name: " + widget.namaTeam),
                  ],
                ),
              )));
      if (result) {
        BlocProvider.of<RegisterBloc>(context).add(AddRegisterTeamEvent(
            namaTeam: widget.namaTeam,
            token: widget.token,
            link: widget.link,
            email: listEmail));
      }
    }
  }
}
