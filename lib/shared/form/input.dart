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
  final TextInputType inputType;
  final double height;
  final Color color;

  TextFormField field;

  Input(
      {this.placeholder,
      this.icon,
      this.obscureText,
      this.onSaved,
      this.controller,
      this.height = 60,
      this.color = Colors.white,
      this.inputType = TextInputType.text,
      this.shadow = true,
      this.label,
      this.before,
      this.after,
      this.validator});

  @override
  Widget build(BuildContext context) {
    this.field = TextFormField(
      obscureText: obscureText ?? false,
      key: key,
      controller: controller,
      decoration: InputDecoration(
          icon: null != this.icon
              ? Icon(
                  this.icon,
                  color: Style.lightGrey,
                )
              : null,
          border: InputBorder.none,
          fillColor: Style.mainColor,
          hintText: this.placeholder),
      onSaved: this.onSaved,
      validator: this.validator,
    );

    return Container(
        height: height + (null != label ? 16 : 0),
        padding: EdgeInsets.only(
          top: (height - 48.0) / 2.0,
          bottom: (height - 48.0) / 2.0,
          left: 10.0,
        ),
        decoration: BoxDecoration(
          color: color,
          boxShadow: shadow
              ? [
                  BoxShadow(
                      color: Style.shadow,
                      offset: Offset(10.0, 10.0),
                      spreadRadius: 3.0,
                      blurRadius: 9.0)
                ]
              : null,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          null != label
              ? Text(label, style: Style.smallLightText)
              : Container(),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            before ?? Container(),
            SizedBox(width: null != before ? 10 : 0,),
            Expanded(child: this.field),
            after ??
                SizedBox(
                  width: 10,
                )
          ])
        ]));
  }
}
