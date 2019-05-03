import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

class Dropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function onChanged;
  final double size;
  final Widget hint;
  final Widget icon;
  final List<BoxShadow> shadow;
  final BoxBorder border;

  Dropdown(
      {this.value,
      this.items,
      this.icon,
      this.onChanged,
      this.size,
      this.hint,
      this.shadow,
      this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        height: 60.0,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          border: border,
          boxShadow: shadow ??
              [
                BoxShadow(
                    color: Style.shadow,
                    offset: Offset(10.0, 10.0),
                    spreadRadius: 3.0,
                    blurRadius: 9.0)
              ],
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(children: [
          icon ?? Container(),
          Expanded(child :DropdownButtonHideUnderline(
              child: DropdownButton<T>(
            elevation: 0,
            isExpanded: true,
            hint: hint,
            value: value,
            items: items,
            onChanged: onChanged,
          )))
        ]));
  }
}