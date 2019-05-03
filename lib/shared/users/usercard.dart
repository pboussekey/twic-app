import 'package:flutter/material.dart';
import 'package:twic_app/api/models/user.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/form/button.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard({this.user});

  @override
  State<StatefulWidget> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160.0,
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.only(top: 10.0),
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
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(20.0),
          child: Column(
            children: <Widget>[
              Avatar(file: widget.user.avatar),
              SizedBox(height: 10.0),
              Text("${widget.user.firstname} ${widget.user.lastname}",
                  style: Style.smallTitle),
              Text(widget.user.school.name, style: Style.smallGreyText),
              SizedBox(height: 10.0),
              ClipRRect(
                  borderRadius: new BorderRadius.circular(4.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                    color: Style.purple,
                    child: Text(
                        "${widget.user.nbFollowers} follower${widget.user.nbFollowers > 1 ? 's' : ''}",
                        style: Style.smallGreyText),
                  )),
              SizedBox(height: 16.0),
              Button(
                border: Border(
                    top: BorderSide(
                        color: Style.border,
                        width: 1.0,
                        style: BorderStyle.solid)),
                radius: null,
                width: 180.0,
                height: 40.0,
                text: widget.user.followed ? 'Followed' : 'Follow',
                background: Colors.white,
                color: widget.user.followed ? Style.grey : Style.lightGrey,
              )
            ],
          ),
        ));
  }
}
