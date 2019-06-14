import 'package:flutter/material.dart';


class Href extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function onPressed;
  final BuildContext context;
  final  WidgetBuilder href;

  Href({this.text, this.onPressed, this.href, this.context, this.style});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: href)),
      child: Text(text, style: style),
    );
  }
}
