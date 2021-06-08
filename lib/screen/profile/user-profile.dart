import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/component/user-profile/text-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/company-model.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/profile/user-edit-profile.dart';
import 'package:zukses_app_1/screen/profile/user-settings.dart';
import 'package:easy_localization/easy_localization.dart';

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
  UserModel user = UserModel();
  @override
  void initState() {
    super.initState();
    _getProfile();
    // print("Id Company " + widget.company.id);
  }

  _getProfile() {
    BlocProvider.of<UserDataBloc>(context).add(UserDataGettingEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Center(
            child: FaIcon(FontAwesomeIcons.pencilAlt,
                color: colorBackground, size: size.height < 569 ? 18 : 22),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          user: user,
                        )));
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
            "profile_text1".tr(),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSettings(user: user)));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  paddingHorizontal, 0, paddingHorizontal, 20),
              child: Stack(
                children: [
                  BlocListener<UserDataBloc, UserDataState>(
                    listener: (context, state) {
                      if (state is UserDataStateSuccessLoad) {
                        setState(() {
                          user = state.userModel;
                        });
                        print(user.imgUrl);
                      }
                    },
                    child: Container(),
                  ),
                  BlocBuilder<UserDataBloc, UserDataState>(
                    builder: (context, state) {
                      if (state is UserDataStateSuccessLoad) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height < 569 ? 5 : 10),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 5, 5),
                                        child: state.userModel.imgUrl == "" ||
                                                state.userModel.imgUrl == null
                                            ? Container(
                                                width:
                                                    size.height < 569 ? 68 : 72,
                                                height:
                                                    size.height < 569 ? 68 : 72,
                                                decoration: BoxDecoration(
                                                  color: colorNeutral2,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                    child: FaIcon(
                                                  FontAwesomeIcons.camera,
                                                  color: colorNeutral3,
                                                )))
                                            : Container(
                                                width:
                                                    size.height < 569 ? 68 : 72,
                                                height:
                                                    size.height < 569 ? 68 : 72,
                                                decoration: BoxDecoration(
                                                    color: colorNeutral2,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          "https://api-zukses.yokesen.com/${state.userModel.imgUrl}",
                                                        ),
                                                        fit: BoxFit.fitWidth)),
                                              )),
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
                                      state.userModel.name,
                                      style: TextStyle(
                                          color: colorPrimary,
                                          fontSize: size.height < 569 ? 16 : 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("profile_text2".tr(),
                                        style: TextStyle(
                                            color: colorPrimary,
                                            fontSize:
                                                size.height < 569 ? 14 : 16))
                                  ],
                                )
                              ],
                            ),
                            widget.company.id == null || widget.company.id == ""
                                ? Container()
                                : SizedBox(
                                    height: size.height < 569 ? 10 : 15,
                                  ),
                            widget.company.id == null || widget.company.id == ""
                                ? Container()
                                : _dataCompany(context, size),
                            SizedBox(
                              height: size.height < 569 ? 10 : 15,
                            ),
                            Container(
                              width: size.width,
                              padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 3, color: Color(0xFFF4F4F4)))),
                              child: Text(
                                "profile_text3".tr(),
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontSize: size.height < 569 ? 14 : 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormat1(
                              size: size,
                              title: "profile_text4".tr(),
                              data: state.userModel.name,
                            ),
                            TextFormat1(
                                size: size,
                                title: "profile_text5".tr(),
                                data: state.userModel.email //"Harus Diisi ",
                                ),
                            TextFormat1(
                                size: size,
                                title: "profile_text6".tr(),
                                data: state.userModel.userID),
                            TextFormat1(
                              size: size,
                              title: "profile_text7".tr(),
                              data: state.userModel.phone == null
                                  ? "profile_text15".tr()
                                  : state.userModel.phone,
                            ),
                            TextFormat1(
                              size: size,
                              title: "profile_text8".tr(),
                              data: state.userModel.email,
                            ),
                          ],
                        );
                      } else if (state is UserDataStateLoading) {
                        return Container(
                          width: size.width,
                          height: 0.8 * size.height,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is UserDataStateFailLoad) {
                        return Container(
                          width: size.width,
                          height: 0.8 * size.height,
                          child: Center(
                            child: Text(
                              "Oops Something Wrong. Please try again.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else if (state is UserDataStateUpdateSuccess) {
                        _getProfile();
                      }
                      return Container();
                    },
                  ),
                ],
              )),
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
            "profile_text10".tr(),
            style: TextStyle(
                color: colorPrimary,
                fontSize: size.height < 569 ? 14 : 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        TextFormat1(
          size: size,
          title: "profile_text11".tr(),
          data: widget.company.name,
        ),
        TextFormat1(
          size: size,
          title: "profile_text12".tr(),
          data: widget.company.code,
        ),
        /*TextFormat1(
          size: size,
          title: "Position",
          data: "Manager TechTeam",
        ),*/
        TextFormat1(
          size: size,
          title: "profile_text14".tr(),
          data: widget.company.email,
        ),
      ],
    );
  }
}
