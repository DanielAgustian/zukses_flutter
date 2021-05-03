import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/apply-leaves/screen-list-leaves.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenInBetween extends StatefulWidget {
  ScreenInBetween({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _ScreenInBetweenState createState() => _ScreenInBetweenState();
}

class _ScreenInBetweenState extends State<ScreenInBetween> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
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
                          builder: (context) =>
                              ScreenListLeaves(permission: "leaves")),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: colorBackground,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [boxShadowStandard]),
                    width: 0.4 * size.width,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/images/leave-icon.svg",
                          height: 80,
                          width: 68,
                        ),
                        Text("Leaves",
                            style: TextStyle(
                                fontSize: size.height < 569 ? 14 : 16,
                                color: colorPrimary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScreenListLeaves(permission: "overtime")),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: colorBackground,
                      boxShadow: [boxShadowStandard],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 0.4 * size.width,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0.05 * size.width),
                          child: SvgPicture.asset("assets/images/overtime.svg",
                              height: 80, width: 68),
                        ),
                        Text(
                          "Overtime",
                          style: TextStyle(
                              fontSize: size.height < 569 ? 14 : 16,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
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
