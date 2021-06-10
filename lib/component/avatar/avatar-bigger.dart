import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AvatarBigger extends StatelessWidget {
  const AvatarBigger({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.width);
    return CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 45 : 50,
              backgroundImage: imageProvider,
            ),
        placeholder: (context, url) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 45 : 50,
              child: Image.asset("assets/images/ava.png"),
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: colorPrimary,
              radius: size.width <= 569 ? 45 : 50,
              child: Image.asset("assets/images/ava.png"),
            ));
  }
}
