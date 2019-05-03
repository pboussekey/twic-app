import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Style {
  static const Color darkGrey = Color.fromARGB(255, 24, 24, 76);
  static const Color grey = Color.fromARGB(255, 113, 103, 141);
  static const Color lightGrey = Color.fromARGB(255, 189, 201, 212);
  static const Color greyBackground = Color.fromARGB(38, 189, 201, 212);
  static const Color veryLightGrey = Color.fromARGB(255, 239,245,251);
  static const Color border = Color.fromARGB(255, 227, 237, 246);
  static const Color shadow = Color.fromARGB(25, 6, 16, 79);
  static const Color red = Color.fromARGB(255, 249, 108, 98);
  static const Color blue = Color.fromARGB(255, 111, 169, 254);
  static const Color purple = Color.fromARGB(255, 234, 242, 249);
  static const Color darkPurple = Color.fromARGB(255, 24,24,76);

  static const Color genZPurple = Color.fromARGB(255, 124,137,253);
  static const Color genZGreen = Color.fromARGB(255, 154,239,202);
  static const Color genZOrange = Color.fromARGB(255, 242,145,114);
  static const Color genZYellow = Color.fromARGB(255, 252,222,120);
  static const Color genZBlue = Color.fromARGB(255, 24,24,76);

  static TextStyle hugeTitle = TextStyle(
      fontSize: 22.0, fontWeight: FontWeight.bold, color: Style.darkGrey, fontFamily: 'Rubik');
  static TextStyle titleStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Style.darkGrey, fontFamily: 'Rubik');
  static TextStyle whiteTitle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Rubik');
  static TextStyle lightTitle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Style.lightGrey, fontFamily: 'Rubik');
  static TextStyle redTitle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Style.red, fontFamily: 'Rubik');


  static TextStyle largeText = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.bold, color: Style.darkGrey, fontFamily: 'Rubik');
  static TextStyle greyText = TextStyle(
      fontSize: 15.0,  color: Style.grey, fontFamily: 'Rubik');
  static TextStyle whiteText = TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'Rubik');
  static TextStyle redText = TextStyle(fontSize: 14.0, color: Style.red, fontFamily: 'Rubik');
  static TextStyle text = TextStyle(fontSize: 14.0, color: Style.darkGrey, fontFamily: 'Rubik');


  static TextStyle smallTitle = TextStyle(
      fontSize: 12.0, fontWeight: FontWeight.bold, color: Style.darkGrey, fontFamily: 'Rubik');
  static TextStyle smallText = TextStyle(fontSize: 12.0, color: Style.darkGrey, fontFamily: 'Rubik');
  static TextStyle lightText =
  TextStyle(fontSize: 12.0, color: Style.lightGrey, fontFamily: 'Rubik');

  static TextStyle smallGreyText =
  TextStyle(fontSize: 11.0, color: Style.grey, fontFamily: 'Rubik');
  static TextStyle smallLightText =
  TextStyle(fontSize: 11.0, color: Style.lightGrey, fontFamily: 'Rubik');
  static TextStyle verySmallWhiteText =
  TextStyle(fontSize: 10.0, color: Style.lightGrey, fontFamily: 'Rubik');
  static TextStyle smallWhiteText =
  TextStyle(fontSize: 11.0, color: Colors.white, fontFamily: 'Rubik');

  static TextStyle hashtagStyle = TextStyle(
      fontSize: 15.0, color: Style.genZPurple, fontFamily: 'Rubik');


  static TextStyle get({double fontSize, Color color}){
    return TextStyle(fontSize: fontSize, color : color, fontFamily: 'Rubik');
  }
}
