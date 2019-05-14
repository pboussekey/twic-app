import 'package:flutter/material.dart';
import 'package:twic_app/style/style.dart';
import 'package:twic_app/pages/home.dart';
import 'package:twic_app/pages/profile/profile.dart';
import 'package:twic_app/pages/discover/discover.dart';
import 'package:twic_app/pages/chat/conversations.dart';
import 'package:twic_app/pages/posts/create.dart';
import 'package:twic_app/api/session.dart';
import 'package:twic_app/shared/users/avatar.dart';
import 'package:twic_app/shared/form/button.dart';
import 'package:twic_app/api/models/post.dart';

enum ButtonEnum { Home, Discover, Create, Profile, Chat }

class BottomNav extends StatelessWidget {
  final ButtonEnum current;
  final Function refresh;
  final Map<String, dynamic> filters = {};

  BottomNav({this.current, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: 24.0,
                color: Style.grey,
              ),
              onPressed: () {
                current == ButtonEnum.Home
                    ? refresh(() {})
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()));
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 24.0,
                  color: Style.grey,
                ),
                onPressed: () {
                  current == ButtonEnum.Discover
                      ? refresh(() {})
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Discover(
                                    filters: filters,
                                  )));
                }),
            Button(
              background: Style.genZPurple,
              height: 24.0,
              width: 40.0,
              radius: BorderRadius.all(Radius.circular(4.0)),
              color: Colors.white,
              fontSize: 18.0,
              text: "+",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreatePost())),
            ),
            IconButton(
              icon: Avatar(
                size: 24.0,
                file: Session.instance.user.avatar,
              ),
              onPressed: () {
                current == ButtonEnum.Profile
                    ? refresh(() {})
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Profile(user_id: Session.instance.user.id)));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                size: 24.0,
                color: Style.grey,
              ),
              onPressed: (){
                current == ButtonEnum.Chat
                    ? refresh(() {})
                    : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ConversationsList()));
              },
            ),
          ],
        ));
  }
}
