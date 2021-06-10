import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AvatarSmaller extends StatelessWidget {
  const AvatarSmaller({
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
              radius: size.width <= 569 ? 15 : 20,
              backgroundImage: imageProvider,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 15 : 20,
              child: Image.asset("assets/images/ava.png"),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 15 : 20,
              child: Image.asset("assets/images/ava.png"),
            ));
  }
}
