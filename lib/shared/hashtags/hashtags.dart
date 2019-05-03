import 'package:flutter/material.dart';
import 'package:twic_app/api/models/hashtag.dart';
import 'package:twic_app/shared/hashtags/hashtag.dart';

class HashtagsList extends StatelessWidget {
  final List<Hashtag> list;
  final Function onPressed;

  HashtagsList({@required this.list, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: new List.generate(list.length,
            (index) =>  Container(
          child: HashtagWidget(
              hashtag: list[index], onPressed:  null != onPressed ? (bool followed) => onPressed(list[index], followed) : null
          ),
          margin: EdgeInsets.only(bottom: 10.0))
    ));
  }
}
