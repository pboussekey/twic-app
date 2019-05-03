import 'package:flutter/material.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/button.dart';

class UserList extends StatelessWidget {
  final List<User> list;

  UserList({this.list});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) => Container(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
              height: 50,
              width: mediaSize.width,
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(
                            file: list[index].avatar,
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  "${list[index].firstname} ${list[index].lastname}",
                                  style: Style.text),
                              Text("${list[index].university.name}",
                                  style: Style.lightText),
                            ],
                          ))
                        ]),
                    Button(
                      height: 30.0,
                      padding: EdgeInsets.only(left : 10.0, right : 10.0),
                      text: list[index].followed ? 'Unfollow' : 'Follow',
                      background: list[index].followed
                          ? Style.veryLightGrey
                          : Colors.white,
                      color: list[index].followed
                          ? Style.lightGrey
                          : Style.lightGrey,
                    )
                  ])),
          itemCount: list.length,
        ));
  }
}