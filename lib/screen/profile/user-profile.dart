import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/user-profile/text-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/company-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/profile/user-edit-profile.dart';
import 'package:zukses_app_1/screen/profile/user-settings.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key, this.title, this.company, this.user}) : super(key: key);
  final String title;
  final CompanyModel company;
  final UserModel user;
  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

/// This is the stateless widget that the main application instantiates.
class _UserProfileScreen extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(user: widget.user,)));
          },
        ),
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
                fontSize: size.height < 570 ? 18 : 22,
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
            padding: EdgeInsets.fromLTRB(
                paddingHorizontal, 0, paddingHorizontal, 20),
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
                          widget.user.name,
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
                _dataCompany(context, size),
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
                  data: widget.user.name,
                ),
                TextFormat1(
                    size: size,
                    title: "Username",
                    data: widget.user.email //"Harus Diisi ",
                    ),
                TextFormat1(
                  size: size,
                  title: "Zukses ID",
                  data: widget.user.userID,
                ),
                TextFormat1(
                  size: size,
                  title: "Phone Number",
                  data: widget.user.phone == null
                      ? "Not Registered"
                      : widget.user.phone,
                ),
                TextFormat1(
                  size: size,
                  title: "Personal Email",
                  data: widget.user.email,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _dataCompany(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 3, color: Color(0xFFF4F4F4)))),
          child: Text(
            "Company",
            style: TextStyle(
                color: colorPrimary,
                fontSize: size.height < 569 ? 14 : 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextFormat1(
          size: size,
          title: "Company Name",
          data: widget.company.name,
        ),
        TextFormat1(
          size: size,
          title: "ID Number",
          data: widget.company.code,
        ),
        TextFormat1(
          size: size,
          title: "Position",
          data: "Manager TechTeam",
        ),
        TextFormat1(
          size: size,
          title: "Company Email",
          data: widget.company.email,
        ),
      ],
    );
  }
}
