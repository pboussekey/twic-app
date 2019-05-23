import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/form/form.dart';

class UserList extends StatelessWidget {
  final List<User> list;
  final Function renderAction;
  final Function onClick;

  UserList({this.list, this.renderAction, this.onClick});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => Button(
            background: Colors.transparent,
              radius: BorderRadius.all(Radius.circular(0)),
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0),
              height: 51,
              onPressed: () => null != onClick ? onClick(list[index]) : null,
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(
                            href: list[index]?.avatar?.href(),
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
                              Text("${list[index].institution.name}",
                                  style: Style.lightText),
                            ],
                          ))
                        ]),
                    null == renderAction ? Button(
                      height: 30.0,
                      padding: EdgeInsets.only(left : 10.0, right : 10.0),
                      text: list[index].followed ? 'Unfollow' : 'Follow',
                      background: list[index].followed
                          ? Style.veryLightGrey
                          : Colors.white,
                      color: list[index].followed
                          ? Style.lightGrey
                          : Style.lightGrey,
                    ) : renderAction(list[index])
                  ])),
          itemCount: list.length,
        ));
  }
}
