import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoundPicture extends StatelessWidget {
  final String picture;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;

  RoundPicture(
      {Key key,
      this.picture,
      this.height,
      this.width,
      this.radius,
      this.fit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 20.0),
      child: picture.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: picture,
              height: height,
              width: width,
              fit: fit,
              placeholder: (context, url) => Center(
                  child: Container(
                      child: CircularProgressIndicator())),
              fadeOutDuration: new Duration(seconds: 1),
              fadeInDuration: new Duration(seconds: 1),
            )
          : Image.asset(
              picture,
              height: height,
              width: width,
              fit: fit,
            ),
    );
  }
}
