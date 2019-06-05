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
  final String label;

  Dropdown(
      {this.value,
      this.items,
      this.icon,
      this.onChanged,
      this.label,
      this.size,
      this.hint,
      this.shadow,
      this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical : 10.0),
        height: null != label ? 82 : 68.0,
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          null != label
              ? Text(label, style: Style.smallLightText)
              : Container(),
          Row(children: [
            icon ?? Container(),
            Expanded(
                child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<T>(
                          elevation: 0,
                          isExpanded: true,
                          hint: hint,
                          value: value,
                          items: items,
                          onChanged: onChanged,
                        ))))
          ])
        ]));
  }
}
