import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class AvatarMedium extends StatelessWidget {
  const AvatarMedium({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              backgroundImage: imageProvider,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              child: Image.asset("assets/images/ava.png"),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              child: Image.asset("assets/images/ava.png"),
            ));
  }
}

class AvatarMediumProject extends StatelessWidget {
  const AvatarMediumProject(
      {Key key, @required this.imgUrl, @required this.projectName})
      : super(key: key);

  final String imgUrl;
  final String projectName;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              backgroundImage: imageProvider,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              child: Center(
                child: Text(
                  Util().getInitials(projectName),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 20 : 30,
              child: Center(
                child: Text(
                  Util().getInitials(projectName),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ));
  }
}
