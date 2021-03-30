import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';

class RegisApproved extends StatefulWidget {
  RegisApproved({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _RegisApprovedScreen createState() => _RegisApprovedScreen();
}

/// This is the stateless widget that the main application instantiates.
class _RegisApprovedScreen extends State<RegisApproved> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
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
                  "Registration Success",
                  style: TextStyle(
                      color: colorGoogle,
                      fontSize: size.height < 569 ? 18 : 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Text(
                  "You have successfully created account",
                  style: TextStyle(
                    color: colorGoogle,
                    fontSize: size.height < 569 ? 12 : 14,
                  ),
                ),
                SizedBox(
                  height: 0.1 * size.width,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: LongButton(
                    size: size,
                    title: "Start Exploring",
                    bgColor: colorPrimary,
                    textColor: colorBackground,
                    onClick: () {},
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
