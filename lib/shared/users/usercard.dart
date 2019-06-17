import 'package:flutter/material.dart';
import 'package:twic_app/api/models/models.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/form/form.dart';
import 'package:twic_app/api/services/users.dart';

class UserCard extends StatefulWidget {
  final int user_id;
  final double width;
  final Function onFollow;

  UserCard({this.user_id, this.width = 160, this.onFollow});

  @override
  State<StatefulWidget> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    User user = Users.list[widget.user_id];
    if(user == null){
      return Container();
    }
    print(user.toJson());
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
              Avatar(href: user?.avatar?.href()),
              SizedBox(height: 12.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("${user.firstname} ${user.lastname}",
                    style: Style.smallTitle),
                null != user.classYear
                    ? Text(
                        "'${user.classYear % 100}",
                        style: Style.lightText,
                      )
                    : Container()
              ]),
              SizedBox(height: 5.0),
              Text(user.institution.name, style: Style.smallGreyText),
              SizedBox(height: 15.0),
              ClipRRect(
                  borderRadius: new BorderRadius.circular(4.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                    color: Style.purple,
                    child: Text(
                        "${user.nbFollowers} follower${user.nbFollowers > 1 ? 's' : ''}",
                        style: Style.smallGreyText),
                  )),
              SizedBox(height: 15.0),
              user.followed
                  ? Users.unfollow(
                      builder: (RunMutation unfollow, QueryResult result) =>
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
                            text:  'Followed' ,
                            background: Colors.white,
                            color: Style.grey,
                            onPressed: () => setState((){
                              user.followed = false;
                              user.nbFollowers--;
                              if(null != widget.onFollow){
                                widget.onFollow(user, false);
                              }
                              unfollow({"user_id":user.id});
                            }),
                          ))
                  : Users.follow(
                      builder: (RunMutation follow, QueryResult result) =>
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
                            text:  'Follow',
                            background: Colors.white,
                            color: Style.mainColor,
                            onPressed: () => setState((){
                              user.followed = true;
                              user.nbFollowers++;
                              if(null != widget.onFollow){
                                widget.onFollow(user, false);
                              }
                              follow({"user_id":user.id});
                            }),
                          ))
            ],
          ),
        ));
  }
}
