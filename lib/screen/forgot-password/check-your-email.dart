import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/forgot-password/reset-password.dart';
import 'package:zukses_app_1/util/util.dart';

class CheckEmail extends StatefulWidget {
  CheckEmail({Key key, this.title, this.email}) : super(key: key);
  final String title;
  final String email;
  @override
  _CheckEmailScreen createState() => _CheckEmailScreen();
}

/// This is the stateless widget that the main application instantiates.
class _CheckEmailScreen extends State<CheckEmail> {
  String _linkMessage = "";

  Future<void> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse(
          'https://zuksesapplication.page.link/forgotpassword?email=' +
              widget.email),
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

    setState(() {
      _linkMessage = url.toString();
    });
  }

  _resendEmail() {
    _createDynamicLink(true);
    //BELOW LOGIC TO SENT DATA TO API
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Util util = Util();
    util.initDynamicLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassword()));
          },
        ),
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    launch(_linkMessage);
                  },
                  child: Text(_linkMessage),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: size.height < 569 ? 100 : 120,
                  height: size.height < 569 ? 100 : 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: colorNeutral2),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: size.height < 569 ? 60 : 100,
                      height: size.height < 569 ? 60 : 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: colorPrimary),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.check,
                          size: size.height < 569 ? 42 : 52,
                          color: colorBackground,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height < 569 ? 15 : 25,
                ),
                Text(
                  "Check Your email",
                  style: TextStyle(
                      color: colorGoogle,
                      fontSize: size.height < 569 ? 18 : 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Container(
                  width: 0.9 * size.width,
                  child: Center(
                    child: Text(
                      "Please check your email and click the given link to reset password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 12 : 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: size.height < 569 ? 12 : 14,
                            color: Colors.black),
                        children: [
                      TextSpan(text: "Didn't receive an email? "),
                      TextSpan(
                          text: "Resend",
                          style: TextStyle(
                              color: colorPrimary, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //Sent Again
                              _resendEmail();
                            })
                    ]))
              ],
            ),
          ),
        ));
  }
}
