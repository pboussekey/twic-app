import 'package:flutter/material.dart';
import 'package:twic_app/shared/components/round_picture.dart';
import 'package:twic_app/style/style.dart';

class Avatar extends StatelessWidget{

  final String href;
  final double size;

  Avatar({this.href, this.size:40.0});

  @override
  Widget build(BuildContext context) {
    return null != this.href
        ? RoundPicture(picture: this.href, width: size, height: size, radius: size, fit: BoxFit.cover,)
        : Icon(
      Icons.account_circle,
      color: Style.grey,
      size: size,
    );
  }
}