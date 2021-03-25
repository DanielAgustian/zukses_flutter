import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/user-profile/textformat-settings.dart';
import 'package:zukses_app_1/constant/constant.dart';
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
                    fontSize: size.height < 570 ? 22 : 25,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                TextFormatSettings(size: size, title: "Receive Notification"),
                TextFormatSettings2(
                    size: size, title: "Language", detail: "English"),
                TextFormatSettings2(
                    size: size,
                    title: "Send Feedback",
                    detail: "We are pleased with your suggestions"),
                InkWell(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    print("Try to Log Out");
                    toLogOut();
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

  toLogOut() async {
    print("Begin Log Out");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/LoginScreen', (Route<dynamic> route) => false);
  }
}
