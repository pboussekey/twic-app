import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoundPicture extends StatelessWidget {
  final String picture;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;
  final EdgeInsetsGeometry padding;
  final Color background;

  RoundPicture(
      {Key key,
      this.picture,
      this.height,
      this.width,
      this.background,
      this.padding,
      this.radius,
      this.fit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 20.0),
        child: Container(
          padding: padding,
          color: background,
          child: picture.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: picture,
                  height: height,
                  width: width,
                  fit: fit,
                  fadeOutDuration: new Duration(seconds: 1),
                  fadeInDuration: new Duration(seconds: 1),
                )
              : Image.asset(
                  picture,
                  height: height,
                  width: width,
                  fit: fit,
                ),
        ));
  }
}
