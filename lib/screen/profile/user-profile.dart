import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/user-profile/text-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/profile/user-settings.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

/// This is the stateless widget that the main application instantiates.
class _UserProfileScreen extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height < 570 ? 22 : 25,
                color: colorPrimary),
          ),
          actions: [
            IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.cog,
                  color: colorPrimary,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserSettings()));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height < 569 ? 5 : 10),
                Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Container(
                              width: size.height < 569 ? 68 : 72,
                              height: size.height < 569 ? 68 : 72,
                              decoration: BoxDecoration(
                                color: colorNeutral2,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: colorNeutral3,
                                ),
                              )),
                        ),
                        Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: size.height < 569 ? 28 : 32,
                                height: size.height < 569 ? 28 : 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.pencilAlt,
                                      color: colorBackground,
                                      size: size.height < 569 ? 12 : 14),
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: size.height < 569 ? 10 : 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Finley Khouwira",
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 569 ? 16 : 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Personal",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height < 569 ? 14 : 16))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: size.height < 569 ? 10 : 15,
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 3, color: Color(0xFFF4F4F4)))),
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                        color: colorPrimary,
                        fontSize: size.height < 569 ? 14 : 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormat1(
                  size: size,
                  title: "Name",
                  data: "Finley Khowira",
                ),
                TextFormat1(
                  size: size,
                  title: "Username",
                  data: "Finley Khowira",
                ),
                TextFormat1(
                  size: size,
                  title: "Zukses ID",
                  data: "Finley Khowira",
                ),
                TextFormat1(
                  size: size,
                  title: "Phone Number",
                  data: "Finley Khowira",
                ),
                TextFormat1(
                  size: size,
                  title: "Personal Email",
                  data: "Finley Khowira",
                ),
              ],
            ),
          ),
        ));
  }
}
