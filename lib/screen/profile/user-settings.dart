import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zukses_app_1/component/user-profile/textformat-settings.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/main.dart';
import 'package:zukses_app_1/screen/screen_login.dart';

class UserSettings extends StatefulWidget {
  UserSettings({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _UserSettingsScreen createState() => _UserSettingsScreen();
}

/// This is the stateless widget that the main application instantiates.
class _UserSettingsScreen extends State<UserSettings> {
  bool isLoading = false;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Stack(
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
                "Settings",
                style: TextStyle(
                    color: colorPrimary,
                    fontSize: size.height < 570 ? 18 : 22,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: colorNeutral2)),
                        color: colorBackground),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Receive Notification",
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
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                TextFormatSettings2(
                    size: size, title: "Language", detail: "English"),
                TextFormatSettings2(
                    size: size,
                    title: "Send Feedback",
                    detail: "We are pleased with your suggestions"),
                InkWell(
                  onTap: () {
                    print("Try to Log Out");
                    //toLogOut();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context));
                  },
                  child: TextFormatSettings2(
                      //onClick: toLogOut(),
                      size: size,
                      title: "Log Out",
                      detail: "Log out from Your Account"),
                ),
              ],
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
    );
  }

  clearAllSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs?.clear();
    prefs.remove("userLogin");
    prefs.remove("passLogin");
    prefs.remove("token");
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
        "Do you want to log out?",
      ),
      content: new Text("Temporary Data will be deleted"),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("Yes"),
            onPressed: () {
              toLogOut();
            }),
        CupertinoDialogAction(
            child: Text("No"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
