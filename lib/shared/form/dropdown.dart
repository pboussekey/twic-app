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
  final Color background;

  Dropdown(
      {this.value,
      this.items,
      this.icon,
      this.onChanged,
      this.label,
      this.size,
      this.hint,
      this.shadow,
      this.border,
      this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
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
              ? Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(label, style: Style.smallLightText))
              : Container(),
          Container(
              color: background,
              height: (null != label ? 62 : 48.0) -
                  (null != border ? border.top.width + border.bottom.width : 0),
              child: Row(children: [
                icon ?? Container(),
                DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                        padding: EdgeInsets.all(0),
                        child: Container(
                            color: background,
                            width: size -
                                (null != border && null != size
                                    ? border.top.width + border.bottom.width
                                    : 0),
                            child: DropdownButton<T>(
                              elevation: 0,
                              isExpanded: true,
                              hint: hint,
                              value: value,
                              items: items,
                              onChanged: onChanged,
                            ))))
              ]))
        ]));
  }
}
