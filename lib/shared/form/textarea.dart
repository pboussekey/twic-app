import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Textarea extends StatelessWidget {
  final String placeholder;
  final Function onSaved;
  final TextEditingController controller;
  final Function validator;
  final TextInputType inputType;
  final Color color;
  final int maxLength;
  final double padding;
  final String label;

  TextFormField field;

  Textarea(
      {this.placeholder,
      this.label,
      this.onSaved,
      this.controller,
      this.maxLength,
      this.padding = 10,
      this.color = Style.grey,
      this.inputType = TextInputType.text,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(bottom: 5.0, right: padding, left: padding, top: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)), color: color),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          null != label
              ? Text(label, style: Style.smallLightText)
              : Container(),
          TextFormField(
            key: key,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: null,
            controller: controller,
            onSaved: onSaved,
            maxLength: maxLength,
            validator: validator,
          )
        ]));
  }
}
