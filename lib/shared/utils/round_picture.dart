import 'package:flutter/material.dart';

class RoundPicture extends StatelessWidget {
  final String picture;
  final double height;
  final double width;
  final double radius;
  final BoxFit fit;

  RoundPicture(
      {Key key, this.picture, this.height, this.width, this.radius, this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 20.0),
      child: picture.startsWith('http') ? Image.network(
        picture,
        height: null != height
            ? this.height
            : (null != fit ? null : 40.0),
        width:
            null != width ? width : (null != fit ? null : 40.0),
        fit: fit,
      ) : Image.asset(
        picture,
        height: null != height
            ? height
            : (null != fit ? null : 40.0),
        width:
        null != width ? width : (null != fit ? null : 40.0),
        fit: fit,
      ),
    );
  }
}
