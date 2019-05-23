import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';

class SchoolCard extends StatefulWidget {
  final School school;

  SchoolCard({this.school});

  @override
  State<StatefulWidget> createState() => SchoolCardState();
}

class SchoolCardState extends State<SchoolCard> {
  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
      width: (mediaSize.width - 50) / 2,
      height: 80,
      margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
      padding: EdgeInsets.only(top : 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Style.shadow,
              offset: Offset(10.0, 10.0),
              spreadRadius: 3.0,
              blurRadius: 9.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            widget.school.logo.href(),
            height: 30,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10.0),
          Text(widget.school.name, style: Style.smallTitle),
        ],
      ),
    );
  }
}
