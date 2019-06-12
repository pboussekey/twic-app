import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/form/form.dart';

class UserCard extends StatefulWidget {
  final User user;
  final double width;

  UserCard({this.user, this.width = 160});

  @override
  State<StatefulWidget> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        padding: EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Style.shadow,
                offset: Offset(10.0, 10.0),
                blurRadius: 30.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(20.0),
          child: Column(
            children: <Widget>[
              Avatar(href: widget.user.avatar?.href()),
              SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [Text("${widget.user.firstname} ${widget.user.lastname}",
                  style: Style.smallTitle),
              null != widget.user.classYear ? Text("'${widget.user.classYear % 100}", style: Style.lightText,) : Container()]),
              SizedBox(height: 5.0),
              Text(widget.user.school.name, style: Style.smallGreyText),
              SizedBox(height: 15.0),
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
              SizedBox(height: 15.0),
              Button(
                border: Border(
                    top: BorderSide(
                        color: Style.border,
                        width: 1.0,
                        style: BorderStyle.solid)),
                radius: null,
                width: widget.width + 20,
                height: 40.0,
                fontSize: 12,
                text: widget.user.followed ? 'Followed' : 'Follow',
                background: Colors.white,
                color: widget.user.followed ? Style.grey : Style.mainColor,
              )
            ],
          ),
        ));
  }
}
