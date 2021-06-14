import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:easy_localization/easy_localization.dart';

class SuccessChange extends StatefulWidget {
  SuccessChange({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SuccessChangeScreen createState() => _SuccessChangeScreen();
}

/// This is the stateless widget that the main application instantiates.
class _SuccessChangeScreen extends State<SuccessChange> {
  _goTo() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ScreenLogin()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    "reset_text6".tr(),
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
                        "reset_text7".tr(),
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
                  LongButton(
                    size: size,
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    title: "Submit",
                    onClick: () {
                      _goTo();
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
