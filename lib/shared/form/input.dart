import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final IconData icon;
  final bool obscureText;
  final bool shadow;
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
      this.height: 60,
      this.color = Colors.white,
      this.inputType = TextInputType.text,
      this.shadow = true,
      this.after,
      this.validator});

  @override
  Widget build(BuildContext context) {
    this.field = TextFormField(
      obscureText: obscureText ?? false,
      key: key,
      controller: controller,
      decoration: InputDecoration(
          icon: Icon(
            this.icon,
            color: Style.lightGrey,
          ),
          border: InputBorder.none,
          fillColor: Style.grey,
          hintText: this.placeholder),
      onSaved: this.onSaved,
      validator: this.validator,
    );

    return Container(
        height: height,
        padding: EdgeInsets.only(
            top: (height - 40.0) / 2.0,
            bottom: (height - 40.0) / 2.0,
            left: 10.0,
            right: 10.0),
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
        child: Row(children: [
          Expanded(child: this.field),
          after ??
              Container(
                width: 10,
              )
        ]));
  }
}
