import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zukses_app_1/component/app-bar/custom-app-bar.dart';
import 'package:zukses_app_1/component/schedule/user-avatar.dart';
import 'package:zukses_app_1/component/text-seq-vertical.dart';
import 'package:zukses_app_1/constant/constant.dart';

class MemberScreen extends StatefulWidget {
  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  DateTime date = DateTime.now();
  final formater = DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: customAppBar(context,
          size: size,
          title: "Team Member",
          leadingIcon: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: colorPrimary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actionList: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 20),
              splashColor: Colors.transparent,
              icon: FaIcon(
                FontAwesomeIcons.plusCircle,
                color: colorPrimary,
                size: size.height < 570 ? 18 : 23,
              ),
              onPressed: () {},
            ),
          ]),
      backgroundColor: colorBackground,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                "${formater.format(date)}",
                style: TextStyle(
                    color: colorPrimary,
                    fontSize: size.height <= 600 ? 16 : 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorNeutral1.withOpacity(1),
                          blurRadius: 15,
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserAvatar(avatarRadius: 20, dotSize: 10),
                      Text(
                        "User 1",
                        style: TextStyle(
                            color: colorPrimary,
                            fontSize: size.height <= 600 ? 14 : 16),
                      ),
                      TextSequentialVertical(
                          size: size,
                          text1: "Start Time",
                          text2: "08.23",
                          textcolor: colorPrimary70),
                      TextSequentialVertical(
                          size: size,
                          text1: "End Time",
                          text2: "17.23",
                          textcolor: colorPrimary),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//   AppBar customAppBar(BuildContext context, Size size) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: colorBackground,
//       leading: IconButton(
//         icon: FaIcon(
//           FontAwesomeIcons.chevronLeft,
//           color: colorPrimary,
//         ),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//       centerTitle: true,
//       title: Text(
//         "Team Member",
//         style: TextStyle(
//             color: colorPrimary,
//             fontWeight: FontWeight.bold,
//             fontSize: size.height <= 569 ? 20 : 25),
//       ),
//       actions: [
//         IconButton(
//           padding: EdgeInsets.only(right: 20),
//           splashColor: Colors.transparent,
//           icon: FaIcon(
//             FontAwesomeIcons.plusCircle,
//             color: colorPrimary,
//             size: size.height < 570 ? 18 : 23,
//           ),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
}
