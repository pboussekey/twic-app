import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget child;
  final Function onPressed;
  final Color background;
  final Color disabledBackground;
  final Color color;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double fontSize;
  final BorderRadiusGeometry radius;
  final BoxBorder border;
  final bool disabled;

  Button(
      {this.text,
      this.onPressed,
      this.background = Style.mainColor,
      this.disabledBackground = Style.darkGrey,
      this.color = Colors.white,
      this.padding,
      this.width,
      this.height,
      this.fontSize,
      this.radius = const BorderRadius.all(Radius.circular(20)),
      this.border,
      this.child,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: disabled ? disabledBackground : background,
            border: border,
            borderRadius: radius),
        height: height,
        width: width,
        child: FlatButton(
          padding: padding ?? EdgeInsets.only(left: 20.0, right: 20.0),
          onPressed: disabled == true ? null : onPressed,
          child: child ??
              Text(text,
                  style: TextStyle(color: color, fontSize: fontSize),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade),
        ));
  }
}
