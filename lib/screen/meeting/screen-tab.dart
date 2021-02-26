import 'package:flutter/cupertino.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-3r-2c.dart';
import 'package:zukses_app_1/component/skeleton/skeleton-less3r-avatar.dart';

class ScreenTabRequest extends StatefulWidget {
  const ScreenTabRequest({Key key, this.screen}) : super(key: key);

  @override
  _ScreenTabRequestState createState() => _ScreenTabRequestState();

  final String screen;
}

class _ScreenTabRequestState extends State<ScreenTabRequest> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => SkeletonLess3WithAvatar(
                size: size,
                row: 2,
              )),
    );
  }
}
