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

  TextFormField field;

  Textarea(
      {this.placeholder,
      this.onSaved,
      this.controller,
      this.maxLength,
      this.color = Style.grey,
      this.inputType = TextInputType.text,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom : 5.0, right: 10.0, left : 10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.0)), color: color),
        child :
        TextFormField(
      key: key,

      decoration: InputDecoration(

        border: InputBorder.none,
      ),
      controller: controller,
      onSaved: onSaved,
      maxLength: maxLength,
      validator: validator,
    ));
  }
}
