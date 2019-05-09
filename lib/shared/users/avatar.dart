import 'package:flutter/material.dart';
import 'package:twic_app/api/models/twic_file.dart';
import 'package:twic_app/shared/utils/round_picture.dart';
import 'package:twic_app/style/style.dart';

class Avatar extends StatelessWidget{

  final TwicFile file;
  final double size;

  Avatar({this.file, this.size:40.0});

  @override
  Widget build(BuildContext context) {
    print("AVATAR $size");
    return null != this.file
        ? RoundPicture(picture: this.file.href(), width: size, height: size, radius: size,)
        : Icon(
      Icons.account_circle,
      color: Style.grey,
      size: size,
    );
  }
}