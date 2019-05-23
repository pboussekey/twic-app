import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/usercard.dart';

class UserCardList extends StatelessWidget{
  final List<User> list;

  UserCardList({this.list});
  @override
  Widget build(BuildContext context) {
    return Container(
        height : 190.0,
        width : double.infinity,
        child : ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) => Padding(padding: EdgeInsets.only(right: 10.0), child: UserCard(user: list[index],),),
      itemCount: list.length,
    ));
  }
}