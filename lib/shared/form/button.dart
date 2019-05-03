import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget child;
  final Function onPressed;
  final Color background;
  final Color color;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double fontSize;
  final double radius;
  final BoxBorder border;
  final bool disabled;

  Button(
      {this.text,
      this.onPressed,
      this.background = Style.genZPurple,
      this.color = Colors.white,
      this.padding,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 20.0,
      this.border,
      this.child,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      child: Container(
          decoration: BoxDecoration(
              color: background,
              border: border,
              borderRadius: null != radius ? BorderRadius.all(Radius.circular(radius)) : null),
          height: height,
          width: width,
          child:
              FlatButton(
                padding: padding ?? EdgeInsets.only(left: 20.0, right: 20.0),
                onPressed: disabled == true ? null : onPressed,
                child:  child ?? Text(text, style: TextStyle(color: color, fontSize: fontSize), textAlign: TextAlign.center,),
              )),
      opacity: disabled ? 0.5 : 1.0,
    );
  }
}