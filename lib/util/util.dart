import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:zukses_app_1/screen/forgot-password/reset-password.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:zukses_app_1/screen/screen_signup.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

class Util {
  String getHourNow() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat.Hm();
    final String formatted = formatter.format(now);
    return formatted;
  }

  String hourFormat(DateTime date) {
    //var now = new DateTime.now();
    //print(now.toString);
    String hour = "";
    if (date == null) {
      hour = DateFormat("HH:mm").format(DateTime.now());
    } else {
      hour = DateFormat("HH:mm").format(date);
    }
    return hour;
  }

  String yearFormat(DateTime date) {
    //var now = new DateTime.now();
    //print(now.toString);
    String year = "";
    if (date == null) {
      year = DateFormat("yyyy-MM-dd").format(DateTime.now());
    } else {
      year = DateFormat("yyyy-MM-dd").format(date);
    }
    return year;
  }

  String acceptancePrint(int num) {
    //num=100 merupakan NULL di DB
    if (num == 100) {
      return "pending";
    } else if (num == 0) {
      return "reject";
    } else if (num == 1) {
      return "accept";
    } else {
      return "Error";
    }
  }

  String changeTimeToString(TimeOfDay time) {
    String hour = "", minutes = "";
    if (time.hour < 10) {
      hour = "0" + time.hour.toString();
    } else {
      hour = time.hour.toString();
    }
    if (time.minute < 10) {
      minutes = "0" + time.minute.toString();
    } else {
      minutes = time.minute.toString();
    }
    return hour + ":" + minutes;
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    return TimeOfDay(
        hour: int.parse(tod.split(":")[0]),
        minute: int.parse(tod.split(":")[1]));
  }

  String cutTime(String time) {
    var temp = Util().stringToTimeOfDay(time);
    return Util().changeTimeToString(temp);
  }
  String dateNumbertoCalendar(DateTime date) {
    return DateFormat('yMMMd').format(date);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  saveSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> createDynamicLink2({bool short, String link}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse(link),
      androidParameters: AndroidParameters(
        packageName: 'com.example.zukses_app_1',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }

  Future<String> createDynamicLink(
      {bool short = false, String value, String key, String page}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse('https://zuksesapplication.page.link/$page?'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.zukses_app_1',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    return url.toString();
  }

  clearSharedPrefString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    //print("INIT DYNAMIC LINK");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sprefToken = prefs.getString("token");



    //================TO GET DYNAMIC LINK WHEN APP IS OPEN==============///
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      //print(deepLink.path);
      print(deepLink);
      if (deepLink != null) {
        print("OnLink Data:");
        if (deepLink.path.toLowerCase().contains("/forgotpassword")) {
          String token = deepLink.queryParameters['token'];
          print("Onlink token" + token);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPassword(
                        token: token,
                      )));
        } else if (deepLink.path.toLowerCase().contains("/registerteam")) {
          print("register");
          if (deepLink.queryParameters['token'] != null) {
            //if he has account
            String token = deepLink.queryParameters['token'];
            print("Onlink token + " + token);

            if (sprefToken != null) {
              //if he has logged in 
              print("Saved Token = " + sprefToken);
              Util().saveSharedPreferences("link", deepLink.toString());

              if (token == sprefToken) {
                //if he is already login and the session hasnt expired.
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenTab(index:0, link: deepLink)));
              } else {
                //if he has login but the session has expired.
                clearSharedPrefString("token");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenLogin(link: deepLink)));
              }
            } else {
              //if he has not login
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenLogin(link: deepLink)));
            }
          } else {
            //if he deosnt have any account
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenSignUp(link: deepLink)));
          }
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });


//=========================TO GET DYNAMIC LINK WHEN APP CLOSED.====================///
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    print(deepLink);
    if (deepLink != null) {
      print("GetInitialLink");

      print("Init" + deepLink.path);
      if (deepLink.path.toLowerCase().contains("/forgotpassword")) {
        String token = deepLink.queryParameters['token'];
        print("Initial Link = " + token);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPassword(
                      token: token,
                    )));
      } else if (deepLink.path.toLowerCase().contains("/registerteam")) {


        if (deepLink.queryParameters['token'] != null) {
            //if he has account
            String token = deepLink.queryParameters['token'];
            print("Onlink token + " + token);

            if (sprefToken != null) {
              //if he has login 
              print("Saved Token = " + sprefToken);
              Util().saveSharedPreferences("link", deepLink.toString());
              if (token == sprefToken) {

                //if he has already login and session not expired
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenTab(index:0, link: deepLink)));
              } else {
                // if he has already login but session expired
                clearSharedPrefString("token");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScreenLogin(link: deepLink)));
              }
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenLogin(link: deepLink)));
            }
          } else {
            Util().saveSharedPreferences("link", deepLink.toString());
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenSignUp(link: deepLink)));
          }
      }
    }
  }

  void showToast(
      {BuildContext context,
      String msg,
      int duration,
      Color color,
      Color txtColor}) {
    Toast.show(msg, context,
        duration: duration,
        gravity: Toast.BOTTOM,
        backgroundColor: color,
        textColor: txtColor);
  }
}
