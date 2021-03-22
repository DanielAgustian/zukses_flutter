import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';

class ScreenInBetween extends StatefulWidget {
  ScreenInBetween({Key key, this.title, }) : super(key: key);

  final String title;
  
  @override
  _ScreenInBetweenState createState() => _ScreenInBetweenState();
}

class _ScreenInBetweenState extends State<ScreenInBetween> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: customAppBar(context,
            size: size,
            leadingIcon: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: colorPrimary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            title: "Permission",
            actionList: [Container()]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenListLeaves(permission:"leaves")),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: colorBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: colorNeutral1.withOpacity(1),
                            blurRadius: 15,
                          )
                        ]),
                    width: 0.4 * size.width,
                    child: Column(
                      children: [
                        Image.asset("assets/images/ava.png"),
                        Text("Leaves",
                            style: TextStyle(
                                fontSize: size.height < 569 ? 14 : 16,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenListLeaves(permission:"overtime")),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorBackground,
                      boxShadow: [
                        BoxShadow(
                          color: colorNeutral1.withOpacity(1),
                          blurRadius: 15,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 0.4 * size.width,
                    child: Column(
                      children: [
                        Image.asset("assets/images/ava.png"),
                        Text(
                          "Overtime",
                          style: TextStyle(
                              fontSize: size.height < 569 ? 14 : 16,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
