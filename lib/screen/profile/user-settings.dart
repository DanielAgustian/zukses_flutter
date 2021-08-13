import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/API/auth-service.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';

import 'package:zukses_app_1/component/user-profile/textformat-settings.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/main.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/contact-supervisor/screen-contact-supervisor-inbox.dart';
import 'package:zukses_app_1/util/util.dart';

class UserSettings extends StatefulWidget {
  UserSettings({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final UserModel user;
  @override
  _UserSettingsScreen createState() => _UserSettingsScreen();
}

/// This is the stateless widget that the main application instantiates.
class _UserSettingsScreen extends State<UserSettings> {
  bool isLoading = false;
  bool switchValue = false;

  List<String> langs = ["English", "Indonesia"];
  String choosedLang;
  String companyId;
  int companyAcceptance;
  @override
  void initState() {
    super.initState();
    companyId = widget.user.companyID;
    companyAcceptance = widget.user.companyAcceptance;
    switchValue = widget.user.notif == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    choosedLang = EasyLocalization.of(context).locale == Locale('id')
        ? langs[1]
        : langs[0];
    Size size = MediaQuery.of(context).size;
    return BlocProvider<UserDataBloc>(
      create: (context) => UserDataBloc(),
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                backgroundColor: colorBackground,
                leading: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: colorPrimary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  "setting_text1".tr(),
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: size.height < 570 ? 18 : 22,
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              body: BlocListener<UserDataBloc, UserDataState>(
                listener: (context, state) {
                  if (state is UserDataStateUpdateFail) {
                    Util().showToast(
                        duration: 3,
                        context: context,
                        msg: "Something wrong",
                        color: colorError,
                        txtColor: colorBackground);
                  } else if (state is UserStateSuccessChangeNotif) {
                    widget.user.notif = switchValue ? 1 : 0;
                  }
                },
                child: BlocBuilder<UserDataBloc, UserDataState>(
                  builder: (context, state) => ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: colorNeutral2)),
                              color: colorBackground),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "setting_text3".tr(),
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontSize: size.height < 570 ? 14 : 16),
                              ),
                              Switch(
                                value: switchValue,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                  BlocProvider.of<UserDataBloc>(context).add(
                                      // UserDataGettingEvent());
                                      UserChangeNotificationStatus(
                                          status: switchValue));
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: colorBackground,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: colorNeutral2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "setting_text2".tr(),
                                    style: TextStyle(
                                        color: colorPrimary,
                                        fontSize: size.height < 570 ? 14 : 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "$choosedLang",
                                    style: TextStyle(
                                        color: colorNeutral3,
                                        fontSize: size.height < 570 ? 12 : 14),
                                  )
                                ],
                              ),
                              DropdownButton(
                                underline: Container(),
                                onChanged: (value) {
                                  EasyLocalization.of(context).setLocale(
                                      value == "Indonesia"
                                          ? Locale("id")
                                          : Locale("en"));
                                  setState(() {
                                    choosedLang = value;
                                  });
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  color: colorPrimary,
                                ),
                                elevation: 16,
                                items: langs.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: colorPrimary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ),
                      companyId == "" && companyAcceptance == 0
                          ? Container()
                          : InkWell(
                              onTap: () {
                                gotoContactSPVList();
                              },
                              child: TextFormatSettings2(
                                  size: size,
                                  title: "setting_text4".tr(),
                                  detail: "setting_text5".tr()),
                            ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialog(context));
                        },
                        child: TextFormatSettings2(
                            //onClick: toLogOut(),
                            size: size,
                            title: "setting_text6".tr(),
                            detail: "setting_text7".tr()),
                      ),
                    ],
                  ),
                ),
              )),
          isLoading
              ? Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black38.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: colorPrimary70,
                      // strokeWidth: 0,
                      valueColor: AlwaysStoppedAnimation(colorBackground),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  // --------------------------Logic-----------------------------//

  clearAllSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs?.clear();
    prefs.remove("userLogin");
    prefs.remove("passLogin");
    prefs.remove("token");
    prefs.remove("myID");
    prefs.remove("in-company");
    if (prefs.getInt("facebook") != null) {
      prefs.remove("facebook");
      prefs.remove("facebook_data");
      prefs.remove("facebook_token");
      AuthServiceHTTP().fbLogOut();
    }
    if (prefs.getInt("google") != null) {
      prefs.remove("google");
      prefs.remove("google_data");
      AuthServiceHTTP().googleLogOut();
    }
  }

  toLogOut() {
    print("Begin Log Out");
    clearAllSharedPref();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  logOut: "logout",
                )),
        (Route<dynamic> route) => false);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new CupertinoAlertDialog(
      title: new Text(
        "profile_text17".tr(),
      ),
      content: new Text("profile_text18".tr()),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text(
              "no_text".tr(),
              style: TextStyle(color: colorError),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        CupertinoDialogAction(
            child: Text(
              "yes_text".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              toLogOut();
            }),
      ],
    );
  }

  gotoContactSPVList() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScreenContactSupervisorInbox()));
  }
}
