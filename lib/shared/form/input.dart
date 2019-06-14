import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final String label;
  final IconData icon;
  final bool obscureText;
  final bool shadow;
  final Widget before;
  final Widget after;
  final Function onSaved;
  final TextEditingController controller;
  final Function validator;
  final Function onSubmitted;
  final TextInputType inputType;
  final double height;
  final double padding;
  final double width;
  final FocusNode focusNode;
  final double iconSize;
  final Color color;

  TextFormField field;

  Input(
      {this.placeholder,
      this.icon,
      this.obscureText,
      this.onSaved,
      this.controller,
      this.height,
      this.padding = 20,
      this.width,
      this.iconSize,
      this.color = Colors.white,
      this.inputType = TextInputType.text,
      this.shadow = true,
      this.label,
      this.before,
      this.onSubmitted,
      this.focusNode,
      this.after,
      this.validator});

  @override
  Widget build(BuildContext context) {
    this.field = TextFormField(
      obscureText: obscureText ?? false,
      key: key,
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
          icon: null != this.icon
              ? Icon(
                  icon,
                  color: Style.lightGrey,
                  size: iconSize,
                )
              : null,
          border: InputBorder.none,
          fillColor: Style.mainColor,
          hintText: this.placeholder),
      onSaved: this.onSaved,
      validator: this.validator,
    );

    return Container(
        height: null != height ? height + (null != label ? 16 : 0) : null,
        width: width,
        padding: EdgeInsets.only(
          top: null != height && height > 48 ? (height - 48.0) / 2.0 : 0,
          bottom: null != height && height > 48 ? (height - 48.0) / 2.0 : 0,
          left: padding,
        ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: shadow
              ? [
                  BoxShadow(
                      color: Style.shadow,
                      offset: Offset(10.0, 10.0),
                      blurRadius: 30.0)
                ]
              : null,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: null != before && null != after ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            before ?? Container(),
            SizedBox(
              width: null != before ? 10 : 0,
            ),
            Expanded(child: this.field),
            after ??
                SizedBox(
                  width: 10,
                )
          ])
        ]) : this.field);
  }
}
