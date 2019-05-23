import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/schools/schoolcard.dart';

class SchoolList extends StatelessWidget {
  final List<School> list;

  SchoolList({this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => Row(children: [
            SchoolCard(school: list[index * 2]),
            SizedBox(width: 10.0,),
            index * 2 + 1 < list.length
                ? SchoolCard(school: list[index * 2 + 1])
                : Container()
          ]),
      itemCount: (list.length / 2).round(),
    ));
  }
}
