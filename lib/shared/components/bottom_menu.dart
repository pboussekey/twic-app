import 'package:flutter/material.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/style/style.dart';

class BottomMenu extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final Function onCancel;

  BottomMenu({this.actions, this.onCancel});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    List<Widget> buttons = [];
    int index = 0;
    actions.forEach((Map<String, dynamic> action) => buttons.add(Button(
          background: Colors.white.withAlpha(200),
          width: mediaSize.width - 20,
          color: Style.grey,
          text: action['text'],
          radius: BorderRadius.only(
              topLeft: Radius.circular(0 == index ? 8.0 : 0),
              topRight: Radius.circular(0 == index ? 8.0 : 0),
              bottomLeft:
                  Radius.circular(actions.length - 1 == index ? 8.0 : 0),
              bottomRight:
                  Radius.circular(actions.length - 1 == index++ ? 8.0 : 0)),
          onPressed: action['onPressed'],
        )));
    if (null != onCancel) {
      buttons.add(SizedBox(
        height: 10,
      ));
      buttons.add(Button(
        background: Colors.white,
        width: mediaSize.width - 20,
        radius: BorderRadius.all(Radius.circular(8.0)),
        color: Style.grey,
        text: "Cancel",
        onPressed: onCancel,
      ));
      buttons.add(SizedBox(
        height: 10,
      ));
    }
    return Positioned.fill(
        child: Container(
            height: mediaSize.height,
            width: mediaSize.width,
            alignment: Alignment(0, 1),
            color: Style.greyBackground.withAlpha(200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: buttons,
            )));
  }
}
