import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/team-model.dart';

class AddMemberScreen extends StatefulWidget {
  final TeamModel team;

  const AddMemberScreen({Key key, this.team}) : super(key: key);
  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: customAppBar(context,
          size: size,
          title: "Edit Member",
          leadingIcon: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorPrimary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actionList: <Widget>[]),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // To Do: Untuk Mulai bikin Add/Edit Member Layout
            ],
          ),
        ),
      ),
    );
  }
}
