import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AvatarBig extends StatelessWidget {
  const AvatarBig({
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
              radius: size.width <= 569 ? 35 : 40,
              backgroundImage: imageProvider,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 35 : 40,
              child: Image.asset("assets/images/ava.png"),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 35 : 40,
              child: Image.asset("assets/images/ava.png"),
            ));
  }
}
