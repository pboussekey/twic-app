import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';

enum AlertType { message, error }

void alert(
    {
    String message,
    Widget icon,
    bool isDismissible = true,
    int duration = 4,
    AlertType type = AlertType.message,
    @required BuildContext context}) {
  Flushbar(
    message:  message,
    flushbarPosition: FlushbarPosition.TOP,
    //Immutable
    reverseAnimationCurve: Curves.decelerate,
    //Immutable
    forwardAnimationCurve: Curves.elasticOut,
    //Immutable
    backgroundColor: type == AlertType.error ? Style.red : Style.genZPurple,
    isDismissible: isDismissible,
    duration: Duration(seconds: duration),
    icon: icon,

    showProgressIndicator: false,
    progressIndicatorBackgroundColor: Colors.blueGrey,
    messageText: new Text(
      message ?? "",
      style: Style.whiteText,
    ),
  ).show(context);
}
