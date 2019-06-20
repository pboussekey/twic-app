import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/style/style.dart';

class CheckBox extends StatelessWidget{

  final Function onPressed;
  final bool isChecked;

  CheckBox({this.onPressed, this.isChecked = false});

  @override
  Widget build(BuildContext context) => Button(
    padding: EdgeInsets.all(0),
    background: Colors.transparent,
    height: 24,
    width: 24,
    onPressed:onPressed,
    child: Container(
      height: 24,
      width: 24,
      padding: EdgeInsets.all(0),
      child: isChecked ? Icon(
        Icons.check,
        color: Colors.white,
        size: 18,
      )
          : null,
      decoration: BoxDecoration(
          color: isChecked
              ? Style.mainColor
              : Colors.transparent,
          borderRadius:
          BorderRadius.all(Radius.circular(12)),
          border: isChecked
              ? null
              : Border.all(color: Style.border)),
    ),
  );
}